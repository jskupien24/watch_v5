//
//  WatchConnector.swift
//  watch_v5
//
//  Created by Fort Hunter on 4/2/25.
//

import Foundation
import WatchConnectivity
import FirebaseAuth
import FirebaseDatabase
import SwiftUI
import MapKit



class WatchConnector: NSObject, WCSessionDelegate, ObservableObject{
    var session: WCSession
    @StateObject private var authViewModel = AuthViewModel()

    
    init(session:WCSession = .default){
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
        print("init")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("session")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Did deactivate")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let entry = parseDiveLogEntry(id: uid , from: message) else { return}
        authViewModel.saveDiveLogEntry(entry)
    }
    
    func parseDiveLogEntry(id: String, from dict: [String: Any]) -> DiveLogEntry? {
        guard
            let date = dict["date"] as? String,
            let duration = dict["duration"] as? String,
            let routeOverview = dict["routeOverview"] as? String,
            let maxDepth = dict["maxDepth"] as? Int,
            let averageHR = dict["averageHR"] as? Int,
            let averageSpeed = dict["averageSpeed"] as? Double,
            let oxygenUsed = dict["oxygenUsed"] as? String,
            let depthData = dict["depthData"] as? [Int],
            let heartRateData = dict["heartRateData"] as? [Int],
            let coordinatesArray = dict["coordinates"] as? [[String: Any]]
        else {
            print("Failed to parse DiveLogEntry")
            return nil
        }

        let coordinates: [DiveLogCoordinate] = coordinatesArray.compactMap { coordDict in
            if let lat = coordDict["latitude"] as? CLLocationDegrees,
               let lon = coordDict["longitude"] as? CLLocationDegrees {
                return DiveLogCoordinate(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            } else {
                return nil
            }
        }
        

        return DiveLogEntry(
            id: UUID(),
            date: date,
            duration: duration,
            routeOverview: routeOverview,
            maxDepth: maxDepth,
            averageHR: averageHR,
            averageSpeed: averageSpeed,
            oxygenUsed: oxygenUsed,
            depthData: depthData,
            heartRateData: heartRateData,
            coordinates: coordinates
        )
    }
}
