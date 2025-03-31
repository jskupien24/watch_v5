//
//  HealthManager.swift
//  watch_v5
//
//  Created by Jack Skupien on 2/24/25.
//

import Foundation
import HealthKit

class HealthManager: ObservableObject{
    let healthStore=HKHealthStore()
    @Published var heartRate: Double = 0.0//stores the latest heart rate
    init(){
//        let heartRateType=HKQuantityType(.heartRate)
        let hr=HKQuantityType(.heartRate)
        let healthTypes: Set = [hr]
        Task{
            do{
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                startHeartRateUpdates()//check for changes in heart rate
            } catch {
                print("error: couldn't fetch health data")
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
        ) { [weak self] _, samples, _, _, _ in
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
        healthStore.execute(query)
    }
}



//#Preview {
//    
//}
