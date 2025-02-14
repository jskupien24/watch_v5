//
//  LogIn.swift
//  watch_v5
//
//  Created by Fort Hunter on 2/13/25.
//
//Simple log in screen will need to be changed later but fine for
//setting up firebase 

import SwiftUI

struct LogIn: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading) {
                Text("Username")
                    .padding(.top, 50)
                TextField("Enter Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 16)
                
                Text("Password")
                SecureField("Enter Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .frame(maxWidth: 400)
            .padding(.horizontal, 16)
            
            Button(action: {
                showAlert = true
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
                title: Text("Submitted Information"),
                message: Text("Username: \(username)\nPassword: \(password)"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    }

#Preview {
    LogIn()
}
