//
//  RootView.swift
//  watch_v5
//
//  Created by Faith Chernowski on 3/31/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSplash = true
    @State private var isLoggedIn = false

    var body: some View {
        if showSplash {
            LaunchScreenView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showSplash = false
                    }
                }
        } else {
            if authViewModel.isAuthenticated {
                ContentView()
            } else {
                LogIn()
            }
        }
    }
}

