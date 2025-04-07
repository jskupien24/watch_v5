//  DiveContainer.swift
//  watch_v5
//      This is a container that is displayed while diving. it holds multiple screens that can be scrolled between. It also begins a workout and turns on waterlock to ignore touch input while underwater
//  Created by Jack Skupien on 3/31/25.

import SwiftUI
import WatchKit

struct DiveContainerView: View {
    @FocusState private var focusedIndex: Int?//for scrollable/tabbed screens
    @EnvironmentObject var manager: HealthManager//for heart rate
    
    //for water lock/exiting the dive computer
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    
    //the below variables are for checking when you turn the water lock off
    @State private var waterLockPreviouslyEnabled = false
    @State private var waterLockTimer: Timer?
    @State private var shouldEnableWaterLock = false
    
    var body: some View{
        TabView{
            //page 1: Metrics
            DiveView().environmentObject(manager).tag(0)
            
            //page 2: Modular Compass
            ModularCompassView().tag(1)
        }
        .tabViewStyle(.carousel)//swap pages with digital crown
        .navigationBarBackButtonHidden(true)
        
        .onAppear {
            print("DiveContainerView appeared — starting workout")
            manager.startDiveWorkout {
                print("Workout started, will enable water lock soon")
                //set flag to water lock
                self.shouldEnableWaterLock = true
            }
            print("after start workout")
        }
        
        //when workout starts
        .onChange(of: manager.workoutStarted) { _, isStarted in
            if isStarted && shouldEnableWaterLock {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    print("Enabling water lock now that workout is running")
                    WKInterfaceDevice.current().enableWaterLock()
                    
                    //reset flag
                    shouldEnableWaterLock = false
                    //check WL status after delay
                    checkWaterLockStatusAfterDelay()
                }
            }
        }
    }
    
    //check water lock status after a delay to allow system to update
    private func checkWaterLockStatusAfterDelay() {
        //wait to check water lock status
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if WKInterfaceDevice.current().isWaterLockEnabled {
                print("Water lock confirmed enabled")
                waterLockPreviouslyEnabled = true
                startWaterLockMonitoring()
            } else {
                print("Water lock status check: not enabled yet, will try again")
                //try again with a longer delay just in case
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    let isLocked = WKInterfaceDevice.current().isWaterLockEnabled
                    print("Final water lock status check: \(isLocked ? "enabled" : "not enabled")")
                    
                    //even if it reports not enabled, we'll still monitor for changes since the UI might show it as locked anyway
                    waterLockPreviouslyEnabled = isLocked
                    startWaterLockMonitoring()
                }
            }
        }
    }
    
    //water lock monitoring
    private func startWaterLockMonitoring() {
        print("Starting water lock monitoring")
        
        //clear existing timers
        waterLockTimer?.invalidate()
        waterLockTimer = nil
        
        //start timer to check both API and manual detection
        waterLockTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let isLocked = WKInterfaceDevice.current().isWaterLockEnabled
            
            //check for unlock every 5 seconds
            if Int(Date().timeIntervalSince1970)%5==0{
                print("Water lock status: \(isLocked ? "locked" : "unlocked")")
            }
            
            //end workout if previously locked and now unlocked
            if waterLockPreviouslyEnabled && !isLocked {
                print("Water Lock was turned off manually")
                waterLockTimer?.invalidate()
                waterLockTimer=nil
                manager.endWorkout()
                dismiss()
            }
            
            //if from unlocked to locked: update our tracking
            if !waterLockPreviouslyEnabled&&isLocked{
                print("Water lock was just enabled")
            }
            waterLockPreviouslyEnabled=isLocked
        }
    }
}

#Preview {
    DiveContainerView().environmentObject(HealthManager())
}
