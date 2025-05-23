//
//  ContentView.swift
//  watch_v5 Watch App
//
//  Created by Jack Skupien on 9/20/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: HealthManager
    var body: some View {
//        VStack {
//            Image("flag")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 100, height: 100)
////                .imageScale(.large)
////                .foregroundStyle(.tint)
//            Text("Hello, Diver!")
//                .bold()
//                .font(.system(size: 16))
//                .frame(width: 100)
//        }
//        .padding()
        selectDive()
        .environmentObject(manager)
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthManager())
}
