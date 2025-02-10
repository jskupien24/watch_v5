//
//  DiveFeed.swift
//  watch_v5
//
//  Created by Faith Chernowski on 2/3/25.
//

import SwiftUI

struct DiveFeed: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Recent Dives")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.horizontal)

                    ForEach(exampleDives, id: \.id) { dive in
                        NavigationLink(destination: DiveDetailView(dive: dive)) {
                            DiveCardView(dive: dive)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .navigationTitle("Diver Down")
            .background(Color.blue.opacity(0.1))
        }
    }
}

struct User {
    let name: String
    let profileImage: String
}

struct NewDive: Identifiable {
    let id = UUID()
    let user: User
    let location: String
    let duration: String
    let depth: String
    let mapImage: String
}

let exampleUsers = [
    User(name: "Diver Name", profileImage: "profile1"),
    User(name: "Diver Name 1", profileImage: "profile2"),
    User(name: "Diver Name 2", profileImage: "profile3"),
    User(name: "Diver Name 3", profileImage: "profile4"),
    User(name: "Diver Name 4", profileImage: "profile5")
]

let exampleDives = [
    NewDive(user: exampleUsers[0], location: "Great Barrier Reef", duration: "45 min", depth: "30m", mapImage: "great_barrier_reef"),
    NewDive(user: exampleUsers[1], location: "Blue Hole, Belize", duration: "50 min", depth: "40m", mapImage: "blue_hole_belize"),
    NewDive(user: exampleUsers[2], location: "Maldives Atolls", duration: "35 min", depth: "25m", mapImage: "maldives_atolls"),
    NewDive(user: exampleUsers[3], location: "Hanauma Bay, Hawaii", duration: "40 min", depth: "20m", mapImage: "hanauma_bay"),
    NewDive(user: exampleUsers[4], location: "Sipadan Island, Malaysia", duration: "55 min", depth: "35m", mapImage: "sipadan_island")
]

struct DiveCardView: View {
    let dive: NewDive
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(dive.user.profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(dive.user.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(dive.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.bottom, 5)
            
            Image(dive.mapImage)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .padding(.top, 5)
            
            HStack {
                Image(systemName: "clock.fill")
                Text(dive.duration)
                Spacer()
                Image(systemName: "arrow.down.to.line")
                Text(dive.depth)
            }
            .font(.subheadline)
            .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.2)).shadow(radius: 2))
        .padding(.horizontal)
    }
}

struct DiveDetailView: View {
    let dive: NewDive
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(dive.user.profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    Text(dive.user.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 5)
                
                Text(dive.location)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)

                Image(dive.mapImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                
                HStack {
                    Image(systemName: "clock.fill")
                    Text("Duration: \(dive.duration)")
                }
                .font(.title2)
                .padding(.top, 5)

                HStack {
                    Image(systemName: "arrow.down.to.line")
                    Text("Depth: \(dive.depth)")
                }
                .font(.title2)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Dive Details")
        .background(Color.blue.opacity(0.1))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        DiveFeed()
    }
}
