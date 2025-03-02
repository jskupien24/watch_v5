//
//  authViewModel.swift
//  watch_v5
//
//  Created by Fort Hunter on 3/1/25.
//

import FirebaseAuth
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var user: FirebaseAuth.User? = nil
    @Published var isAuthenticated = false

    init() {
        user = Auth.auth().currentUser
        isAuthenticated = user != nil
    }

    func logIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let authResult = authResult {
                DispatchQueue.main.async {
                    self.user = authResult.user
                    self.isAuthenticated = true
                    completion(true)
                }
            }
            else{
                completion(false)
            }
        }
    }

    func logOut() {
        try? Auth.auth().signOut()
        DispatchQueue.main.async {
            self.user = nil
            self.isAuthenticated = false
        }
    }
}
