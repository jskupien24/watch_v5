//
//  Settings.swift
//  watch_v5
//
//  Created by Fort Hunter on 4/7/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showLogin = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account")) {
                    Button {
                        authViewModel.logOut()
                        print("Logged out")
                        showLogin = true
                    } label: {
                        HStack {
                            Image(systemName: "arrow.backward.square")
                            Text("Log Out")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .fullScreenCover(isPresented: $showLogin) {
            ContentView()
        }
    }
}
