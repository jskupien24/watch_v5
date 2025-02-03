//
//  ContentView.swift
//  watch_v5
//
//  Created by Jack Skupien on 9/20/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {//nav menu at the bottom
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            MyDivesView()
                .tabItem {
                    Label("My Dives", systemImage: "water.waves").symbolEffect(.breathe.pulse.byLayer/*, options: .nonRepeating*/)
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

// Preview provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//import SwiftUI
//
//struct NavBar: View {
//    var body: some View {
//        TabView{
//            HomeScreen()
//                .tabItem(){
//                    Image(systemName:"house.fill")
//                    Text("Home")
//                }
//            Dives()
//                .tabItem(){
//                    Image(systemName:"water.waves").symbolEffect(.breathe.pulse.byLayer, options: .nonRepeating)
//                    Text("Dives")
//                }
//            Profile()
//                .tabItem(){
//                    Image(systemName:"person.fill")
//                    Text("Profile")
//                }
//        }
//        VStack{
//            
//        }
//    }
//}

//#Preview {
//    NavBar()
//}
