//
//  HomeScreen.swift
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
            TabView{
                HomeScreen()
                    .tabItem(){
                        Image(systemName:"phone.fill")
                        Text("Home")
                    }
                Dives()
                    .tabItem(){
                        Image(systemName:"phone.fill")
                        Text("Dives")
                    }
                Profile()
                    .tabItem(){
                        Image(systemName:"phone.fill")
                        Text("Profile")
                    }
                /*
                 struct ContentView: View {
                 var body: some View 1
                 TabView {
                 ViewA()
                 •tabItem ) {
                 Image (systemName: "phone.fill")
                 Text ("Calls")
                 }
                 ViewB( )
                 • tabItem {
                 Image (systemName: "person.2.fill")
                 Text ("Contacts")
                 ViewC()
                 • tabItem {
                 Image (systemName: "slider.horizontal.3")
                 Text ("Settings")
                 */
            }
        }
        .padding()
    }
}

#Preview {
    HomeScreen()
}
