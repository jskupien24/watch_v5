//
//  LogIn.swift
//  watch_v5
//
//  Created by Fort Hunter on 2/13/25.
//
//Simple log in screen will need to be changed later but fine for
//setting up firebase 

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct LogIn: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var loggedIn: Bool = false
    @State private var alertMessage: String = ""
    @State private var userInfo: [String: Any]? = nil
    @State private var navigateToHome = false
    @State private var navigateToSignUp = false
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Email")
                        .padding(.top, 50)
                    TextField("Enter Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 16)
                    
                    Text("Password")
                    SecureField("Enter Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .frame(maxWidth: 400)
                .padding(.horizontal, 16)
                
                Button(action: {
                    authViewModel.logIn(email: email, password: password){success in
                        if success{
                        navigateToHome = true
                    }}
                }) {
                    Text("Submit")
                        .frame(maxWidth: 300)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                Button("Sign Up") {
                    navigateToSignUp = true
                }
                .padding()
                .foregroundColor(.blue)
                
                .frame(maxWidth: 300)
                .padding(.bottom, 50)
                .navigationDestination(isPresented: $navigateToHome) {
                    ContentView().environmentObject(authViewModel)
                }
                .navigationDestination(isPresented: $navigateToSignUp) {
                    SignUp() 
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGray6))
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Authentication"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
                
            }
        }
        
    }
   
    }

#Preview {
    LogIn()
}
