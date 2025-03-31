//
//  LaunchScreenView.swift
//  watch_v5
//
//  Created by Faith Chernowski on 3/31/25.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var fadeIn = false

    var body: some View {
        VStack {
            Spacer()
            Image("flag")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .opacity(fadeIn ? 1 : 0)
                .animation(.easeIn(duration: 2.0), value: fadeIn)
            
            Text("Welcome, Diver")
                .font(.title2)
                .foregroundColor(.gray)
                .opacity(fadeIn ? 1 : 0)
                .animation(.easeIn(duration: 2.5), value: fadeIn)
                .padding(.top, 16)
            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            fadeIn = true
        }
    }
}
