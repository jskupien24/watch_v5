//
//  Profile.swift
//  watch_v5
//
//  Created by Jack Skupien on 11/18/24.
//

import SwiftUI

// ProfileView.swift
struct ProfileView: View {
    @StateObject private var authViewModel = AuthViewModel()
    var body: some View {
            NavigationView {
                VStack {
                    //                Text("")
                    //                    .font(.largeTitle)
                    //                    .padding()
                    
                    HStack{
                        //profile picture
                        Image("ProfilePicture")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundStyle(.tint)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom:10, trailing: 5))
                        
                        //                    Spacer()
                        //profile info
                        VStack(alignment: .leading){
                            
                            Text("\(authViewModel.userData["name"] ?? "Name")").font(.system(size:28, weight: .semibold))
                            Text("\(authViewModel.userData["bio"] ?? "Bio")").font(.system(size:23, weight: .light))
                            //                            //.foregroundColor(.accentColor)
                            //                        Text("Master Diver (Candidate)").font(.system(size:23, weight: .light))
                            //.foregroundColor(.accentColor)
                            //                        Text("Rescue Diver").font(.system(size:18, weight: .light))
                            //                        Text("Advanced Diver").font(.system(size:18, weight: .light))
                            //                        Text("Open Water Diver").font(.system(size:18, weight: .light))
                        }
                    }
                    Spacer()
                    Text("[Profile Content Placeholder]").foregroundColor(.accentColor)
                    Spacer()
                }
                .navigationTitle("My Profile")
            }
        }
}
