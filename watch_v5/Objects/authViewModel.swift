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
}
