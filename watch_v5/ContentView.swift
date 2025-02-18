//
//  ContentView.swift
//  watch_v5
//
//  Created by Jack Skupien on 9/20/24.
//
// Edited by Faith Chernowski on 2/3/2025
// added feed page to the nav bar

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

struct ContentView: View {
    @State private var selectedTab = 0
    var body: some View {
        VStack {
            //assign tabs
            if selectedTab == 0 {
                DiveSiteFeedView()
            } else if selectedTab == 1 {
                MyDivesView()
            } else if selectedTab == 2 {
                DiveFeed()
            } else {
                ProfileView()
            }
            
            //show tab bar at bottom
            HStack {
                TabButton(title: "Home", icon: "house.fill", index: 0, selectedTab: $selectedTab)
                    .padding(EdgeInsets(top: 50, leading: 10, bottom:0, trailing: 20))
                TabButton(title: "My Dives", icon: "water.waves", index: 1, selectedTab: $selectedTab)
                    .padding(EdgeInsets(top: 50, leading: 20, bottom:0, trailing: 20))
                TabButton(title: "Feed", icon: "list.number", index: 2, selectedTab: $selectedTab)
                    .padding(EdgeInsets(top: 50, leading: 20, bottom:0, trailing: 20))
                TabButton(title: "Profile", icon: "person.fill", index: 3, selectedTab: $selectedTab)
                    .padding(EdgeInsets(top: 50, leading: 20, bottom:0, trailing: 10))
            }
            .background(Color.white)
        }
    }
}

struct TabButton: View {
    var title: String
    var icon: String
    var index: Int
    @Binding var selectedTab: Int
    
    @State private var pulse = false
    
    var body: some View {
        Button(action: {
            selectedTab = index
            pulse.toggle()
        }) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(selectedTab == index ? .accentColor : .gray)
                    .symbolEffect(.bounce, options: .nonRepeating, value: pulse)
                    .scaleEffect(pulse ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: pulse)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(selectedTab == index ? .accentColor : .gray)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

//preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
