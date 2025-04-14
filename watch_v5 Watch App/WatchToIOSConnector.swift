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
    
    
    func sendDataToPhone(data: [String: Any]){
        if WCSession.default.activationState != .activated {
            print("WCSession is not activated yet.")
            return
        }
        
        if session.isReachable {
            print("Sending Dive data")
            
            session.sendMessage(data, replyHandler: nil){ error in
                print("error senind dive data")
                print(error.localizedDescription)
            }
        }
        else{
            print("Session is not reachable")
        }
    }

    
}
