//
//  HealthManager.swift
//  watch_v5
//
//  Created by Jack Skupien on 2/24/25.
//

import Foundation
import HealthKit
import WatchKit

class HealthManager: NSObject, ObservableObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    //for heart rate
    let healthStore=HKHealthStore()
    @Published var heartRate: Double = 0.0//stores the latest heart rate
    
    //for workout session
    var workoutSession: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    @Published var workoutStarted = false
    
    override init(){
        super.init()
        let hr=HKQuantityType(.heartRate)
        let workout=HKObjectType.workoutType()
//        let healthTypes: Set = [hr]
        let typesToShare: Set = [workout]
        let typesToRead: Set = [hr, workout]
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead)
                startHeartRateUpdates()
                print("HealthKit authorized")
            } catch {
                print("HealthKit not authorized: \(error)")
            }
        }
    }
    
    func startHeartRateUpdates(){
        let heartRateType=HKObjectType.quantityType(forIdentifier: .heartRate)!
        let query=HKAnchoredObjectQuery(
            type: heartRateType,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ){ [weak self] _, samples, _, _, _ in
            //begin updated code-- everything from here to the block comment used to be the block comment
            self?.handleHeartRateSamples(samples)
        }
        query.updateHandler = { [weak self] _, samples, _, _, _ in
            self?.handleHeartRateSamples(samples)
        }
            
            /*
            guard let self=self, let quantitySamples = samples as? [HKQuantitySample] else { return }
            if let latestSample=quantitySamples.last {
                DispatchQueue.main.async {
                    self.heartRate=latestSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                }
            }
        }
        
        query.updateHandler={ [weak self] _, samples, _, _, _ in
            guard let self=self, let quantitySamples=samples as? [HKQuantitySample] else { return }
            if let latestSample=quantitySamples.last{
                DispatchQueue.main.async{
                    self.heartRate=latestSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                }
            }
        }
         */
        healthStore.execute(query)
    }
    private func handleHeartRateSamples(_ samples: [HKSample]?) {
        guard let quantitySamples = samples as? [HKQuantitySample],
              let latestSample = quantitySamples.last else { return }
        
        DispatchQueue.main.async {
            self.heartRate = latestSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
        }
    }
    
    //vvWORKOUT SESSION CODEvv
    func startDiveWorkout() {
        guard workoutSession == nil else {
            print("Workout session already exists.")
            return
        }
        //check for workout permission
        let status = healthStore.authorizationStatus(for: HKObjectType.workoutType())
        print("Workout permission status: \(status.rawValue)")

        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other
        configuration.locationType = .unknown // <- safer for now

        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = workoutSession?.associatedWorkoutBuilder()
            builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)

            workoutSession?.delegate = self
            builder?.delegate = self

            workoutSession?.startActivity(with: Date())
            builder?.beginCollection(withStart: Date()) { success, error in
                if let error = error {
                    print("beginCollection failed: \(error.localizedDescription)")
                } else {
                    print("Workout builder collection started.")
                }
            }

        } catch {
            print("Failed to start workout: \(error.localizedDescription)")
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("Workout state changed: \(toState.rawValue)")
        
        DispatchQueue.main.async {
            self.workoutStarted = (toState == .running)
        }
        
        if toState == .ended {
            // Only finish if the workout ended successfully
            self.builder?.finishWorkout { workout, error in
                if let error = error {
                    print("Error finishing workout: \(error)")
                } else {
                    print("Workout finished.")
                }
            }
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed: \(error.localizedDescription)")
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        //logic to handle new data
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        //Called when events (like pauses/resumes) are recorded
    }

    func endWorkout() {
        guard let session = workoutSession else { return }

        if session.state == .running || session.state == .paused {
            print("Ending workout session...")
            session.end() // This will trigger didChangeTo
        } else {
            print("Workout not in a state that can be ended.")
        }
    }
}



//#Preview {
//    
//}
