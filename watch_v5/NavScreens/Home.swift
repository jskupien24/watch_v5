//
//  HomeView.swift
//  watch_v5
//
//  Created by Jack Skupien on 2/3/25.
//
// HomeView.swift

import SwiftUI
struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Home Content")//middle text
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Home")//top left text
        }
    }
}

