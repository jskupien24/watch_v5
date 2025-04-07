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
    private var hasFinishedWorkout = false
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
                print("HealthKit authorized\n")
            } catch {
                print("HealthKit not authorized: \(error)\n")
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
            //begin updated code
            self?.handleHeartRateSamples(samples)
        }
        query.updateHandler = { [weak self] _, samples, _, _, _ in
            self?.handleHeartRateSamples(samples)
        }
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
    private func resetWorkoutSession() {
        workoutSession = nil
        builder = nil
        hasFinishedWorkout = false
        print("Workout session and builder reset\n")
    }

    func startDiveWorkout(completion: @escaping () -> Void) {
        guard workoutSession == nil else {
            print("Workout session already exists.")
            return
        }
        //check for workout permissionw
        let status = healthStore.authorizationStatus(for: HKObjectType.workoutType())
        print("Workout permission status: \(status.rawValue)")

        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other
        configuration.locationType = .indoor//previously .unknown

        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = workoutSession?.associatedWorkoutBuilder()
            builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)

            workoutSession?.delegate = self
            builder?.delegate = self
            builder?.beginCollection(withStart: Date()) { success, error in
                if success {
                    self.workoutSession?.startActivity(with: Date())
                    DispatchQueue.main.async {
                        self.workoutStarted = true
                        print("Workout builder collection started.")
                        completion()//triggers waterlock?
                    }
                } else {
                    print("beginCollection failed: \(error?.localizedDescription ?? "Unknown error")")
                    // Clean up if starting fails
                    self.resetWorkoutSession()
                }
            }
        } catch {
            print("Failed to start workout: \(error.localizedDescription)")
            // Clean up if setup fails
            resetWorkoutSession()
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                            from fromState: HKWorkoutSessionState, date: Date) {
        print("Workout state changed: \(toState.rawValue)")

        switch toState {
        case .running:
            // Update state when workout starts
            DispatchQueue.main.async {
                self.workoutStarted = true
                print("HealthManager: Workout Started (true)")
            }

        case .ended:
            // Only attempt to finish if we haven't already done so
            guard !self.hasFinishedWorkout else {
                print("Finish workout already called; skipping.")
                return
            }
            self.hasFinishedWorkout = true

            // Proceed only if the session state is really ended
            if workoutSession.state == .ended, let builder = builder {
                builder.endCollection(withEnd: Date()) { success, error in
                    if let error = error {
                        print("Error ending collection: \(error.localizedDescription)")
                        // Even on error, we should clean up
                        DispatchQueue.main.async {
                            self.workoutStarted = false
                            self.resetWorkoutSession()
                        }
                    } else {
                        print("Collection ended.")
                        builder.finishWorkout { workout, error in
                            if let error = error {
                                print("Error finishing workout: \(error.localizedDescription)")
                            } else {
                                print("Workout finished successfully: \(String(describing: workout))")
                            }
                            // Always clean up, whether success or failure
                            DispatchQueue.main.async {
                                self.workoutStarted = false
                                self.resetWorkoutSession()
                            }
                        }
                    }
                }
            } else {
                print("Workout session is not in the expected ended state.")
                // Clean up anyway
                DispatchQueue.main.async {
                    self.workoutStarted = false
                    self.resetWorkoutSession()
                }
            }

        default:
            break
        }
    }


    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed: \(error.localizedDescription)")
        // Clean up on failure
        DispatchQueue.main.async {
            self.workoutStarted = false
            self.resetWorkoutSession()
        }
    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        //logic to handle new data
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        //Called when events (like pauses/resumes) are recorded
    }

    func endWorkout() {
        print("Ending workout session...")

        guard let session = workoutSession else {
            print("No active session to end.")
            return
        }

        // Only end the session if it hasn't been ended already
        if session.state == .ended || session.state == .notStarted {
            print("Workout session already ended or not started.")
            // Still reset references to be safe
            DispatchQueue.main.async {
                self.resetWorkoutSession()
            }
            return
        }
        session.end()
    }
}
