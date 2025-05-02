////
////  WatchToIOSConnector.swift
////  watch_v5
////
////  Created by Fort Hunter on 4/2/25.
////

import Foundation
import WatchConnectivity
import SwiftUI

class WatchToIOSConnector: NSObject, WCSessionDelegate, ObservableObject {
    @Published var diveLocations: [String] = []

    override init() {
        super.init()

        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("Watch WCSession activated")
        } else {
            print("WCSession is not supported on this device.")
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch session activated with state: \(activationState.rawValue)")
        if let error = error {
            print("Activation error: \(error.localizedDescription)")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("Watch received message with replyHandler: \(message)")
        if let locations = message["Dives"] as? [String] {
            DispatchQueue.main.async {
                self.diveLocations = locations
            }
            replyHandler(["status": "received"])
        } else {
            replyHandler(["status": "invalid message"])
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("Watch received message: \(message)")
        if let locations = message["Dives"] as? [String] {
            DispatchQueue.main.async {
                self.diveLocations = locations
            }
        }
    }
}
