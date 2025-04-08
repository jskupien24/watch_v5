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
    @State private var showChangeBioSheet = false
    @State private var newBio = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account")) {
                    Button {
                        showChangeBioSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Change Bio")
                        }
                    }
                    .foregroundColor(.blue)

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
        .sheet(isPresented: $showChangeBioSheet) {
            VStack(spacing: 20) {
                Text("Update Your Bio")
                    .font(.headline)

                TextField("Enter new bio", text: $newBio)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Save") {
                    authViewModel.changeBio(bio: newBio)
                    showChangeBioSheet = false
                }
                .tint(.blue)
                .padding()
                .buttonStyle(.borderedProminent)

                Button("Cancel") {
                    showChangeBioSheet = false
                }
                .foregroundColor(.red)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showLogin) {
            ContentView()
        }
    }
}
