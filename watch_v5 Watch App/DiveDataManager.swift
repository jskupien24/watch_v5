import Foundation
import HealthKit
import CoreMotion
import Combine

class DiveDataManager: ObservableObject {
    private var healthStore = HKHealthStore()
    private var motionManager = CMMotionManager()

    @Published var depth: Double = 0.0
    @Published var heartRate: Double = 0.0
    @Published var ascentRate: Double = 0.0
    @Published var diveDuration: Double = 0.0

    private var startTime: Date?

    init() {
        requestHealthKitPermission()
        startMonitoring()
    }

    private func requestHealthKitPermission() {
        let typesToRead: Set = [HKObjectType.quantityType(forIdentifier: .heartRate)!]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if !success {
                print("HealthKit Authorization Failed: \(String(describing: error?.localizedDescription))")
            }
        }
    }

    private func startMonitoring() {
        startHeartRateMonitoring()
        startDepthMonitoring()
        startAscentRateMonitoring()
    }

    private func startHeartRateMonitoring() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }

        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { _, _, _ in
            self.fetchLatestHeartRate()
        }
        
        healthStore.execute(query)
    }

    private func fetchLatestHeartRate() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }

        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, results, _ in
            if let sample = results?.first as? HKQuantitySample {
                DispatchQueue.main.async {
                    self.heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                }
            }
        }

        healthStore.execute(query)
    }

    private func startDepthMonitoring() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 1.0
            motionManager.startDeviceMotionUpdates(to: .main) { data, error in
                if let attitude = data?.attitude {
                    let pitch = attitude.pitch
                    self.depth = max(0, pitch * 10) // Simulated conversion for testing
                }
            }
        }
    }

    private func startAscentRateMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let newDepth = self.depth
            self.ascentRate = abs(newDepth - self.depth) // Change in depth per second
            self.depth = newDepth
        }
    }

    func startDiveTimer() {
        startTime = Date()
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            if let start = self.startTime {
                self.diveDuration = Date().timeIntervalSince(start) / 60
            }
        }
    }
}
