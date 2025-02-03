//
//  Homeview2.swift
//  watch_v5
//
//  Created by Faith Chernowski on 2/3/25.
//
//import SwiftUI
//struct Homeview2: View {
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(alignment: .leading) {
//                    Text("Recent Dives")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .foregroundColor(.blue)
//                        .padding(.horizontal)
//
////                    ForEach(exampleDives, id: \ .id) { dive in
////                        DiveCardView(dive: dive)
////                    }
//                }
//            }
//            .navigationTitle("Diver Down")
//            .background(Color.blue.opacity(0.1))
//        }
//    }
//}
//
//struct Dive: Identifiable {
//    let id = UUID()
//    let location: String
//    let duration: String
//    let depth: String
//    let mapImage: String // New field for dive route image
//}
//
//let exampleDives = [
//    Dive(location: "Great Barrier Reef", duration: "45 min", depth: "30m", mapImage: "great_barrier_reef"),
//    Dive(location: "Blue Hole, Belize", duration: "50 min", depth: "40m", mapImage: "blue_hole_belize"),
//    Dive(location: "Maldives Atolls", duration: "35 min", depth: "25m", mapImage: "maldives_atolls"),
//    Dive(location: "Hanauma Bay, Hawaii", duration: "40 min", depth: "20m", mapImage: "hanauma_bay"),
//    Dive(location: "Sipadan Island, Malaysia", duration: "55 min", depth: "35m", mapImage: "sipadan_island")
//]
//
//struct DiveCardView: View {
//    let dive: Dive
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Image(systemName: "map.fill")
//                    .foregroundColor(.blue)
//                Text(dive.location)
//                    .font(.headline)
//            }
//            
//            HStack {
//                Image(systemName: "clock.fill")
//                Text(dive.duration)
//                Spacer()
//                Image(systemName: "arrow.down.to.line")
//                Text(dive.depth)
//            }
//            .font(.subheadline)
//            .foregroundColor(.gray)
//            
//            Image(dive.mapImage) // Displays dive route image
//                .resizable()
//                .scaledToFit()
//                .cornerRadius(10)
//                .padding(.top, 5)
//        }
//        .padding()
//        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.2)).shadow(radius: 2))
//        .padding(.horizontal)
//    }
//}
//
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        Homeview2()
//    }
//}



