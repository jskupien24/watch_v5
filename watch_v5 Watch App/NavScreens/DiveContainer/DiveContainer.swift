//  DiveContainer.swift
//  watch_v5
//      This is a container that is displayed while diving. it holds
//          multiple screens that can be scrolled between.
//      It also begins a workout and turns on waterlock to ignore touch
//          input while underwater
//  Created by Jack Skupien on 3/31/25.

import SwiftUI
import WatchKit

struct DiveContainerView: View {
    @FocusState private var focusedIndex: Int?//for scrollable/tabbed screens
    @EnvironmentObject var manager: HealthManager//for heart rate
    
    //for water lock/exiting the dive computer
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    var body: some View{
        TabView{
            //Page 1: Metrics
            DiveMetricsView().environmentObject(manager).tag(0)
            
            //Page 2: Modular Compass
            ModularCompassView().tag(1)
        }
        .tabViewStyle(.carousel)//swap pages with digital crown
        .navigationBarBackButtonHidden(true)
        
        .onAppear {
            print("DiveContainerView appeared — starting workout")
            manager.startDiveWorkout()
            print("after start workout")
        }
        
        .onChange(of: manager.workoutStarted) { isRunning, _ in
            if isRunning {
                WKInterfaceDevice.current().enableWaterLock()
                print("Water Lock enabled after workout started.")
            }
        }
        
        .onChange(of: scenePhase) { newPhase, _ in
            print("ScenePhase changed: \(newPhase)")
//            if newPhase == .active {
//                // Assume water lock has been turned off manually
//                print("App became active — assuming Water Lock was disabled")
//                manager.endWorkout()
//                dismiss()
//            }
        }
    }
}


#Preview {
    DiveContainerView().environmentObject(HealthManager())
}
