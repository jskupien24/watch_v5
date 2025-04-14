//
//  authViewModel.swift
//  watch_v5
//
//  Created by Fort Hunter on 3/1/25.
//

import FirebaseAuth
import FirebaseDatabase
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var user: FirebaseAuth.User? = nil
    @Published var isAuthenticated = false
    @Published var userData: [String: Any] = [:]
    
    private let databaseRef = Database.database().reference()

    init() {
        self.user = Auth.auth().currentUser
        if let user = self.user {
            self.isAuthenticated = true
            fetchUserData(uid: user.uid) 
        }
    }
    
    func signUp(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                if let authResult = authResult {
                    self.user = authResult.user
                    self.isAuthenticated = true
                    self.saveUserData(uid: authResult.user.uid, name: name, email: email)
                    completion(true)
                } else {
                    print("Sign-up failed: \(error?.localizedDescription ?? "Unknown error")")
                    completion(false)
                }
            }
        }
    }
    
    func saveUserData(uid: String, name: String, email: String) {
        let userData: [String: Any] = [
            "name": name,
            "email": email,
            "createdAt": Date().timeIntervalSince1970
        ]
        
        databaseRef.child("users").child(uid).setValue(userData) { error, _ in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.userData = userData
                }
            }
        }
    }

    func logIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let authResult = authResult {
                DispatchQueue.main.async {
                    self.user = authResult.user
                    self.isAuthenticated = true
                    self.fetchUserData(uid: authResult.user.uid)
                    completion(true)
                }
            }
            else{
                completion(false)
            }
        }
    }
    
    func fetchUserData(uid: String) {
        databaseRef.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            if let data = snapshot.value as? [String: Any] {
                DispatchQueue.main.async {
                    self.userData = data
                }
            }
        }
    }

    func logOut() {
        try? Auth.auth().signOut()
        DispatchQueue.main.async {
            self.user = nil
            self.isAuthenticated = false
            self.userData = [:]
        }
    }
    
    func changeBio(bio: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let bioRef = databaseRef.child("users").child(uid).child("bio")
        bioRef.setValue(bio) { error, _ in
            if let error = error {
                print("Error updating bio: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.userData["bio"] = bio
                }
            }
        }
    }
    func saveDiveLogEntry(_ entry: DiveLogEntry) {
        guard let uid = user?.uid else {
            print("User not authenticated")
            return
        }

        let entryId = entry.id.uuidString
        let coordinatesData = entry.coordinates.map { ["latitude": $0.coordinate.latitude, "longitude": $0.coordinate.longitude] }

        let diveData: [String: Any] = [
            "date": entry.date,
            "duration": entry.duration,
            "routeOverview": entry.routeOverview,
            "maxDepth": entry.maxDepth,
            "averageHR": entry.averageHR,
            "averageSpeed": entry.averageSpeed,
            "oxygenUsed": entry.oxygenUsed,
            "depthData": entry.depthData,
            "heartRateData": entry.heartRateData,
            "coordinates": coordinatesData
        ]

        databaseRef.child("users").child(uid).child("diveLogs").child(entryId).setValue(diveData) { error, _ in
            if let error = error {
                print("Error saving dive log: \(error.localizedDescription)")
            } else {
                print("Dive log saved successfully.")
            }
        }
    }
    
}
