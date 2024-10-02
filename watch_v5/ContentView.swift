//
//  ContentView.swift
//  watch_v5
//
//  Created by Jack Skupien on 9/20/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {//vertical stack container
            //add globe image
            Image("customImage")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
//                .frame(width: 100.0, height: 100.0)
//                .resizable()
                //.imageScale(.large)
                .foregroundStyle(.tint)
            //add text
            Text("Hello, Diver!")
                .bold()
                .font(.system(size: 32))
                .frame(width: 200)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
