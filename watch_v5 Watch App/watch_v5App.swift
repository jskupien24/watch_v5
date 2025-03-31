//
//  watch_v5App.swift
//  watch_v5 Watch App
//
//  Created by Jack Skupien on 9/20/24.
//

import SwiftUI

@main
struct watch_v5_Watch_AppApp: App {
    @StateObject var manager = HealthManager()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(manager)
        }
    }
}
