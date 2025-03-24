//
//  LocationManager.swift
//  watch_v5
//
//  Created by Jack Skupien on 3/24/25.
//

import Foundation
import CoreLocation

class LocationManager: NSObject,ObservableObject,CLLocationManagerDelegate{
    var locationManager=CLLocationManager()
    @Published var authorizationstatus: CLAuthorizationStatus?
    
    var latitude:Double{
        locationManager.location?.coordinate.latitude ?? 5.555555//this'll just be a default
    }
    var longitude:Double{
        locationManager.location?.coordinate.longitude ?? 4.444444
    }
    
    override init(){
        super.init()
        locationManager.delegate=self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .authorizedWhenInUse:
            //available when in use
            authorizationstatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
        case .restricted:
            authorizationstatus = .restricted
            break
        case .denied:
            authorizationstatus = .denied
            break
        case .notDetermined:
            authorizationstatus = .notDetermined
            manager.requestLocation()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("\(error.localizedDescription)")
    }
}
