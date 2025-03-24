//
//  CompassManager.swift
//  watch_v5
//
//  Created by Jack Skupien on 3/24/25.
//

import CoreLocation
import Combine

class CompassManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var heading: Double = 0.0
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        if CLLocationManager.headingAvailable() {
            locationManager.delegate = self
            locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            self.heading = newHeading.magneticHeading
        }
    }
}
