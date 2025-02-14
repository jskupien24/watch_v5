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
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var userInfo: [String: Any]? = nil
    
    var body: some View {
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
                logInUser()
            }) {
                Text("Submit")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .frame(maxWidth: 300)
            .padding(.bottom, 50)
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
    private func logInUser() {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    alertMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                    return
                }

                guard let userID = authResult?.user.uid else {
                    alertMessage = "Unable to retrieve user ID."
                    showAlert = true
                    return
                }

                fetchUserData(userID: userID)
            }
        }

        private func fetchUserData(userID: String) {
            let databaseRef = Database.database().reference()
            databaseRef.child("users").child(userID).observeSingleEvent(of: .value) { snapshot in
                if let data = snapshot.value as? [String: Any] {
                    self.userInfo = data
                    let name = data["name"] as? String ?? "N/A"
                    let bio = data["bio"] as? String ?? "N/A"
                    alertMessage = """
                                    User Information:
                                    Name: \(name)
                                    Bio : \(bio)
                                    Email: \(email)
                                    """
                    showAlert = true
                } else {
                    alertMessage = "No user data found."
                    showAlert = true
                }
            } withCancel: { error in
                alertMessage = "Error: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

#Preview {
    LogIn()
}
