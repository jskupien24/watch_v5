//
//  Profile.swift
//  watch_v5
//
//  Created by Jack Skupien on 11/18/24.
//

import SwiftUI

// ProfileView.swift
struct ProfileView: View {
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
                        Text("Jack Skupien").font(.system(size:28, weight: .semibold))
                        Text("Master Diver (Candidate)").font(.system(size:23, weight: .light))
                            //.foregroundColor(.accentColor)
                        Text("Rescue Diver").font(.system(size:18, weight: .light))
                        Text("Advanced Diver").font(.system(size:18, weight: .light))
                        Text("Open Water Diver").font(.system(size:18, weight: .light))
                    }//.padding()
                }
                Spacer()
                Text("[Profile Content Placeholder]").foregroundColor(.accentColor)
                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
}
