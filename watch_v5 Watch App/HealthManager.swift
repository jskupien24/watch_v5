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
    init(){
        let hr=HKQuantityType(.heartRate)
        let healthTypes: Set = [hr]
        Task{
            do{
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch {
                print("error: couldn't fetch health data")
            }
        }
    }
}

//#Preview {
//    
//}
