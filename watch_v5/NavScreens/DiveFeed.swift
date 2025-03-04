//
//  DiveFeed.swift
//  watch_v5
//
//  Created by Faith Chernowski on 2/3/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    let dive: NewDive  // Stored property
    
    @State private var region: MKCoordinateRegion
    
    init(dive: NewDive) {
        self.dive = dive  // Initialize self.dive first
        
        _region = State(initialValue: MKCoordinateRegion(
            center: dive.coordinates.first?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: dive.coordinates) { item in
            MapMarker(coordinate: item.coordinate, tint: .blue)
        }
    }
}


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
}

struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct NewDive: Identifiable {
    let id = UUID()
    let user: User
    let location: String
    let duration: String
    let depth: String
    let waterTemp: String
    let visibility: String
    let coordinates: [IdentifiableCoordinate]
    let diveImage: String // Hardcoded dive image
}

let exampleUsers = [
    User(name: "John Diver"),
    User(name: "Alice Explorer"),
    User(name: "Emma Sea"),
    User(name: "Mark Ocean"),
    User(name: "Sophie Deep")
]

let exampleDives = [
    NewDive(user: exampleUsers[0], location: "Great Barrier Reef", duration: "45 min", depth: "30m", waterTemp: "27°C", visibility: "20m",
            coordinates: [
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: -16.918, longitude: 145.778)),
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: -16.919, longitude: 145.780)),
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: -16.920, longitude: 145.782))
            ], diveImage: "greatbarrierreef"),
    
    NewDive(user: exampleUsers[1], location: "Blue Hole, Belize", duration: "50 min", depth: "40m", waterTemp: "25°C", visibility: "30m",
            coordinates: [
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: 17.315, longitude: -87.534)),
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: 17.316, longitude: -87.536)),
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: 17.317, longitude: -87.538))
            ], diveImage: "bluehole"),
    
    NewDive(user: exampleUsers[2], location: "Maldives Atolls", duration: "35 min", depth: "25m", waterTemp: "28°C", visibility: "25m",
            coordinates: [
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: 3.2028, longitude: 73.2207)),
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: 3.2030, longitude: 73.2210)),
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: 3.2032, longitude: 73.2215))
            ], diveImage: "maldives"),

    NewDive(user: exampleUsers[3], location: "Hanauma Bay, Hawaii", duration: "40 min", depth: "20m", waterTemp: "26°C", visibility: "15m",
            coordinates: [
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: 21.269, longitude: -157.693)),
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: 21.270, longitude: -157.695)),
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: 21.271, longitude: -157.697))
            ], diveImage: "hawaii"),

    NewDive(user: exampleUsers[4], location: "Sipadan Island, Malaysia", duration: "55 min", depth: "35m", waterTemp: "29°C", visibility: "35m",
            coordinates: [
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: 4.117, longitude: 118.628)),
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: 4.118, longitude: 118.630)),
                IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: 4.119, longitude: 118.632))
            ], diveImage: "sipadan")
]

struct DiveCardView: View {
    let dive: NewDive
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.circle.fill") // Pre-coded SwiftUI profile icon
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                
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
            
            MapView(dive: dive)
                .frame(height: 200)
                .cornerRadius(10)

            Image(dive.diveImage)
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
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                    
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
                
                MapView(dive: dive)
                    .frame(height: 300)
                    .cornerRadius(10)

                Image(dive.diveImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack { Image(systemName: "clock.fill"); Text("Duration: \(dive.duration)") }
                    HStack { Image(systemName: "arrow.down.to.line"); Text("Depth: \(dive.depth)") }
                    HStack { Image(systemName: "thermometer.sun.fill"); Text("Water Temp: \(dive.waterTemp)") }
                    HStack { Image(systemName: "eye.fill"); Text("Visibility: \(dive.visibility)") }
                }
                .font(.title2)
                .padding(.top, 5)

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
