//
//  ContentView.swift
//  watch_v5
//
//  Created by Jack Skupien on 9/20/24.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        VStack {//vertical stack container
            //add dd flag image
            Image("flag")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundStyle(.tint)
            //add text
            Text("Hello, Diver!")
                .bold()
                .font(.system(size: 32))
                .frame(width: 200)
        }
    }
}

#Preview {
    HomeScreen()
}
