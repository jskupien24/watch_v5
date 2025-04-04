//
//  WatchConnector.swift
//  watch_v5
//
//  Created by Fort Hunter on 4/2/25.
//

import Foundation
import WatchConnectivity

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject{
    var session: WCSession
    
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
        print("Before3")
        print(message)
        print("After3")
    }
    
}
