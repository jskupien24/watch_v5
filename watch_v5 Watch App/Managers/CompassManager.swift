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
    @Published var direction: String = "N"
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
            self.direction = self.getCompassDirection(from: newHeading.magneticHeading)
        }
    }
    
    private func getCompassDirection(from heading: Double) -> String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"]
        let index = Int((heading / 45.0).rounded()) % 8
        return directions[index]
    }
}
