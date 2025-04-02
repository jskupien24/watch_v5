//
//  ConnectivityManager.swift
//  watch_v5
//
//  Created by Fort Hunter on 4/2/25.
//
import WatchConnectivity

class WatchConnectivityHelper: NSObject, WCSessionDelegate {
    
    static let shared = WatchConnectivityHelper()  // Singleton to access this class easily
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // Function to send user info from Watch to iPhone
    func sendUserInfoToPhone(userInfo: [String: Any]) {
        WCSession.default.transferUserInfo(userInfo)
        print("User info sent from Watch to iPhone.")
    }
    
    // Handle incoming user info from iPhone
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
        print("Received user info from iPhone: \(userInfo)")
        
        if let username = userInfo["username"] as? String,
               let score = userInfo["score"] as? Int {
                print("User \(username) has a score of \(score)")
            }
    }
    
    // Handle session activation
    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Session activation failed: \(error.localizedDescription)")
        } else {
            print("Session activated successfully with state: \(state.rawValue)")
        }
    }
    
    // Remove sessionDidBecomeInactive and sessionDidDeactivate for watchOS
    // These are only supported on iOS
}
