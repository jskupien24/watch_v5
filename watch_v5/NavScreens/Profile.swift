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
                
                //add profile picture
                Image("ProfilePicture")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(.tint)
                
                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
}
