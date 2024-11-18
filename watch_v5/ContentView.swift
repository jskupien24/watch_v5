//
//  ContentView.swift
//  watch_v5
//
//  Created by Jack Skupien on 9/20/24.
//

import SwiftUI

struct NavBar: View {
    var body: some View {
        TabView{
            HomeScreen()
                .tabItem(){
                    Image(systemName:"house.fill")
                    Text("Home")
                }
            Dives()
                .tabItem(){
                    Image(systemName:"water.waves").symbolEffect(.breathe.pulse.byLayer, options: .nonRepeating)
                    Text("Dives")
                }
            Profile()
                .tabItem(){
                    Image(systemName:"person.fill")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    NavBar()
}
