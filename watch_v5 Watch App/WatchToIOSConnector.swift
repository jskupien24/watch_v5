//
//  WatchToIOSConnector.swift
//  watch_v5
//
//  Created by Fort Hunter on 4/2/25.
//

import Foundation
import WatchConnectivity

class WatchToIOSConnector: NSObject, WCSessionDelegate, ObservableObject{
    var session: WCSession
    
    init(session:WCSession = .default){
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        }
    func sendDataToPhone(){
        if session.isReachable {
            let data: [String: Any] = [
                "Test": "working"
            ]
            
            session.sendMessage(data, replyHandler: nil)
        }
        else{
            print("Session is not reachable")
        }
    }

    
}
