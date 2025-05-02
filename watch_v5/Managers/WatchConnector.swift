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

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    @StateObject private var authViewModel = AuthViewModel()

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
        print("iOS WCSession initialized")
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("iOS session activation completed with state: \(activationState.rawValue)")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("iOS session became inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("iOS session did deactivate")
        session.activate() // Good practice to re-activate if needed
    }

    // ✅ Message from watch WITHOUT reply handler
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("iOS received message: \(message)")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let entry = parseDiveLogEntry(id: uid, from: message) else { return }
        authViewModel.saveDiveLogEntry(entry)
    }

    // ✅ Message from watch WITH reply handler (REQUIRED to silence error!)
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("iOS received message with replyHandler: \(message)")

        guard let uid = Auth.auth().currentUser?.uid else {
            replyHandler(["status": "no uid"])
            return
        }

        guard let entry = parseDiveLogEntry(id: uid, from: message) else {
            replyHandler(["status": "invalid entry"])
            return
        }

        authViewModel.saveDiveLogEntry(entry)
        replyHandler(["status": "saved"])
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

    // 🔁 Optional: send message from iOS to Watch
    func sendMessageToWatch(_ message: [String: Any]) {
        if session.isReachable {
            session.sendMessage(message, replyHandler: { reply in
                print("Reply from watch: \(reply)")
            }, errorHandler: { error in
                print("Failed to send message to watch: \(error.localizedDescription)")
            })
        } else {
            print("Watch session is not reachable")
        }
    }
}
