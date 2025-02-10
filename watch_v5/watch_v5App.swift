//
//  watch_v5App.swift
//  watch_v5
//
//  Created by Jack Skupien on 9/20/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct watch_v5App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    let databaseRef = Database.database().reference()

    
    var body: some Scene {
        
        WindowGroup {
            HomeScreen()
        }
    }
}
