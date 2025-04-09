////
////  WatchToIOSConnector.swift
////  watch_v5
////
////  Created by Fort Hunter on 4/2/25.
////
//
import Foundation
import WatchConnectivity

class WatchToIOSConnector: NSObject, WCSessionDelegate, ObservableObject{
    var session: WCSession
    
    init(session:WCSession = .default){
        self.session = session
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        } else {
            print("WCSession is not supported on this device.")
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
        if let error = error {
            print("WCSession activation error: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
        
        }
    
    
    func sendDataToPhone(){
        
        if WCSession.default.activationState != .activated {
            print("WCSession is not activated yet.")
            return
        }
        
        if session.isReachable {
            print("before before")
            let data: [String: Any] = [
                "fats": "5", "date": "2023-12-24, 23:18:27 +0000",
                "createdAt": "2023-10-24 22:18:44 +0000", "food":
                "soup", "carbs": "15", "protein":
                "3"
            ]
            print("before")
            session.sendMessage(data, replyHandler: nil){ error in
                print("here")
                print(error.localizedDescription)
            }
            print("after")
        }
        else{
            print("Session is not reachable")
        }
    }

    
}
