//
//  MyDives.swift
//  watch_v5
//
//  Created by Jack Skupien on 2/3/25.
//

import SwiftUI

// MyDivesView.swift
struct MyDivesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("My Dives Content")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("My Dives")
        }
    }
}
