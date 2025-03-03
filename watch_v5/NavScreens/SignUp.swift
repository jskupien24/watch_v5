//
//  SignUp.swift
//  watch_v5
//
//  Created by Fort Hunter on 3/3/25.
//
import SwiftUI

struct SignUp: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Full Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Sign Up") {
                    authViewModel.signUp(name: name, email: email, password: password) { success in
                        if success {
                            DispatchQueue.main.async {
                                navigateToHome = true
                            }
                        }
                    }
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            .navigationDestination(isPresented: $navigateToHome) {
                ContentView().environmentObject(authViewModel) // ✅ Navigate after sign-up
            }
        }
    }
}
