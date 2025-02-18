//
//  Discovery.swift
//  watch_v5
//
//  Created by Faith Chernowski on 2/8/25.
//

import SwiftUI
import CoreLocation
import MapKit

// MARK: - DiveSite Model
struct DiveSite: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let coordinate: CLLocationCoordinate2D

    var imageURLs: [String] {
        let query = name.replacingOccurrences(of: " ", with: "-").lowercased()
        return (1...3).map { "https://source.unsplash.com/400x300/?scuba-diving,\(query),ocean&sig=\($0)" }
    }
}

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            DispatchQueue.main.async {
                self.userLocation = location.coordinate
            }
        }
    }
}

// MARK: - Sample Dive Sites
let sampleDiveSites = [
    DiveSite(name: "Blue Hole", description: "A deep, circular sinkhole with marine life.", coordinate: CLLocationCoordinate2D(latitude: 24.5271, longitude: -87.6278)),
    DiveSite(name: "Shark Reef", description: "A popular site with frequent shark sightings.", coordinate: CLLocationCoordinate2D(latitude: 25.3000, longitude: -80.1500)),
    DiveSite(name: "Coral Gardens", description: "Vibrant coral reefs and colorful fish.", coordinate: CLLocationCoordinate2D(latitude: 26.2000, longitude: -81.5000))
]

// MARK: - Dive Site Feed View
struct DiveSiteFeedView: View {
    @StateObject private var locationManager = LocationManager()
    
    var sortedDiveSites: [DiveSite] {
        guard let userLocation = locationManager.userLocation else { return sampleDiveSites }
        return sampleDiveSites.sorted {
            let distance1 = CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude).distance(from: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude))
            let distance2 = CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude).distance(from: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude))
            return distance1 < distance2
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: - Fixed Header with Updated Gradient
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.5)]),
                                   startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.top)

                    VStack(spacing: 4) {
                        Text("Nearby Dive Spots")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)

                        if let userLocation = locationManager.userLocation {
                            Text("Searching near: \(userLocation.latitude), \(userLocation.longitude)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        } else {
                            Text("Finding your location...")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.top, max(UIApplication.shared.connectedScenes
                        .compactMap { ($0 as? UIWindowScene)?.windows.first?.safeAreaInsets.top }
                        .first ?? 10, 10))
                    .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100) // Adjusted header height

                // MARK: - Dive Feed List
                ScrollView {
                    VStack {
                        ForEach(sortedDiveSites) { site in
                            NavigationLink(destination: DiveSiteDetailView(diveSite: site)) {
                                DiveSiteCard(diveSite: site)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
                .background(Color.blue.opacity(0.1))
            }
        }
    }
}

// MARK: - Dive Site Card with Improved Image Handling
struct DiveSiteCard: View {
    let diveSite: DiveSite

    var body: some View {
        VStack(alignment: .leading) {
            // Image Carousel with Improved Placeholder
            TabView {
                ForEach(diveSite.imageURLs, id: \.self) { url in
                    AsyncImage(url: URL(string: url)) { phase in
                        if let image = phase.image {
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 180)
                                .clipped()
                        } else if phase.error != nil {
                            Image("fallback-dive") // Replace with a default image asset
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipped()
                        } else {
                            ProgressView()
                                .frame(height: 180)
                        }
                    }
                }
            }
            .frame(height: 180)
            .tabViewStyle(PageTabViewStyle())

            // Dive Site Information
            VStack(alignment: .leading, spacing: 5) {
                Text(diveSite.name)
                    .font(.headline)
                    .foregroundColor(.red)
                
                Text(diveSite.description)
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            .padding()
        }
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 3))
        .padding(.bottom, 10)
    }
}

// MARK: - Dive Site Detail View
struct DiveSiteDetailView: View {
    let diveSite: DiveSite
    
    var body: some View {
        VStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: diveSite.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )), annotationItems: [diveSite]) { site in
                MapMarker(coordinate: site.coordinate, tint: .red)
            }
            .frame(height: 300)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(diveSite.name)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)
                
                Text(diveSite.description)
                    .font(.body)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            
            Spacer()
        }
        .background(Color.white)
        .navigationTitle(diveSite.name)
    }
}

// MARK: - SwiftUI Previews
struct DiscoveryView_Previews: PreviewProvider {
    static var previews: some View {
        DiveSiteFeedView()
    }
}





