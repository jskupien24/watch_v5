//
//  ContentView.swift
//  watch_v5
//
//  Created by Jack Skupien on 9/20/24.
//
// Edited by Faith Chernowski on 2/3/2025
// added feed page to the nav bar

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

struct ContentView: View {
    let connector = WatchConnector()
    @StateObject private var authViewModel = AuthViewModel()
    @State private var isLoggedIn = true
    var body: some View {
        Group{
            if authViewModel.isAuthenticated {
                //show navigation tab buttons
                NavBar().navigationBarBackButtonHidden(true)
            } else{
                LogIn()
                    .environmentObject(authViewModel)
            }
        }
    }
}

//preview
struct ContentView_Previews: PreviewProvider {
    @StateObject private var authViewModel = AuthViewModel()
    static var previews: some View {
        ContentView()
    }
}
