//
//  ContentView.swift
//  watch_v5
//
//  Created by Jack Skupien on 9/20/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
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

// HomeView.swift
struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Home")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Home")
        }
    }
}

// MyDivesView.swift
struct MyDivesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("My Dives")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("My Dives")
        }
    }
}

// ProfileView.swift
struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Profile")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Profile")
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
