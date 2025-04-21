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
    let depth: Double
    let waterTemperature: Double
    let visibility: Double
    let rating: Double
    let imageNames: [String] // Local images
}

// MARK: - Location Manager (Find User's GPS Position)
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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

// MARK: - Dive Site ViewModel
class DiveSiteViewModel: ObservableObject {
    @Published var diveSites: [DiveSite] = []
    
    func fetchNearbyDiveSites() {
        self.diveSites = [
            DiveSite(name: "Loch Low-Minn",
                     description: "A spring-fed quarry with freshwater jellyfish and clear visibility.",
                     coordinate: CLLocationCoordinate2D(latitude: 35.6043, longitude: -84.4724),
                     depth: 30.0, waterTemperature: 16.0, visibility: 20.0, rating: 4.5,
                     imageNames: ["loch1", "loch2", "loch3"]),
            
            DiveSite(name: "Philadelphia Quarry",
                     description: "A popular dive site with various sunken structures and aquatic life.",
                     coordinate: CLLocationCoordinate2D(latitude: 35.6745, longitude: -84.4172),
                     depth: 40.0, waterTemperature: 18.0, visibility: 25.0, rating: 4.7,
                     imageNames: ["phillie1", "phillie2", "phillie3"]),
            
            DiveSite(name: "Martha’s Quarry",
                     description: "A deep freshwater dive with sunken boats and training platforms.",
                     coordinate: CLLocationCoordinate2D(latitude: 36.0053, longitude: -86.3771),
                     depth: 35.0, waterTemperature: 17.0, visibility: 22.0, rating: 4.6,
                     imageNames: ["martha1", "martha2", "martha3"])
        ]
    }
}

// MARK: - Dive Site Card
struct DiveSiteCard: View {
    let diveSite: DiveSite
    
    var body: some View {
        VStack(alignment: .leading) {//whole card
            TabView {
                ForEach(diveSite.imageNames, id: \ .self) { imageName in
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                }
            }
            .frame(height: 250)
            .tabViewStyle(PageTabViewStyle())
            
            //info under pictures
            VStack(alignment: .leading, spacing: 8) {
                Text(diveSite.name)
                    .font(.title2)
                    .bold()
                
                Text(diveSite.description)
                    .font(.body)
                    .foregroundColor(.gray)
                
                HStack {
                    Text("🌊 Depth: \(diveSite.depth, specifier: "%.0f")m")
                    Text("🌡 Temp: \(diveSite.waterTemperature, specifier: "%.0f")°C")
                    Text("🔭 Visibility: \(diveSite.visibility, specifier: "%.0f")m")
                }
                .font(.headline)
                .foregroundColor(.blue)

                //Conditions View
                ConditionsView(
                    depth: Int(diveSite.depth),
                    temp: Int(diveSite.waterTemperature),
                    vis: Int(diveSite.visibility)
                )
                
//                Text("⭐ \(diveSite.rating, specifier: "%.1f") / 5.0")
//                    .font(.headline)
//                    .foregroundColor(.orange)
                StarsView(rating: diveSite.rating,
                          maxRating: 5)
                .padding(.leading, -70)
//                .scaleEffect(0.75)
            }
            .padding()
        }
        .background(
            RoundedRectangle(
                cornerRadius: 12
            )
            .fill(Color.appearance/*.opacity(0.75)*/)
            .shadow(radius: 5))
        .padding(.bottom, 10)
    }
}

// MARK: - Dive Site Detail View
struct DiveSiteDetailView: View {
    let diveSite: DiveSite
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                TabView {
                    ForEach(diveSite.imageNames, id: \ .self) { imageName in
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipped()
                    }
                }
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle())
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(diveSite.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text(diveSite.description)
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("🌊 Depth:\n \(diveSite.depth, specifier: "%.0f")m")
                        Text("🌡 Temp:\n \(diveSite.waterTemperature, specifier: "%.0f")°C")
                        Text("🔭 Visibility:\n \(diveSite.visibility, specifier: "%.0f")m")
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    
                    Text("⭐ \(diveSite.rating, specifier: "%.1f") / 5.0")
                        .font(.title2)
                        .foregroundColor(.orange)
                        .bold()
                }
                .padding()
                
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: diveSite.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )), annotationItems: [diveSite]) { site in
                    MapMarker(coordinate: site.coordinate, tint: .red)
                }
                .frame(height: 350)
                .cornerRadius(12)
                .padding()
            }
        }
        .navigationTitle(diveSite.name)
    }
}

// MARK: - Dive Site Feed View
struct DiveSiteFeedView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = DiveSiteViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Nearby Dive Spots")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .onAppear {
                        viewModel.fetchNearbyDiveSites()
                    }
                
                ScrollView {
                    VStack {
                        ForEach(viewModel.diveSites) { site in
                            NavigationLink(destination: DiveSiteDetailView(diveSite: site)) {
                                DiveSiteCard(diveSite: site)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }
}


//MARK: - Rating Indicator
struct StarsView: View {
    var rating: CGFloat
    var maxRating: Int

    var body: some View {
        HStack{
            let stars = HStack(spacing: 0) {
                ForEach(0..<maxRating, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            
            stars.overlay(
                GeometryReader { g in
                    let width = rating / CGFloat(maxRating) * g.size.width
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: width)
                    }
                }
                    .mask(stars)
            )
            .foregroundColor(.reverseAppearance.opacity(0.15))
            .scaleEffect(0.4)
            Spacer()
//            .padding(.trailing, 100)
        }.frame(width: 250)
    }
}

//MARK: - Conditions Stack (Depth, Temp, Vis)
struct ConditionsView: View{
    var depth: Int
    var temp: Int
    var vis: Int
    let lineHeight=30.0
    let lineWidth=1.0
    var body: some View{
        HStack {
            Spacer()
            //Depth Stack
            VStack(alignment:.center){
                Text("Depth")
                    .foregroundStyle(.reverseAppearance.opacity(0.7))
                Text("\(depth, specifier: "%.0f")m")
                    .font(.system(size: 32, weight: .medium, design: .rounded))
//                    .foregroundColor(.gray)
                    .foregroundStyle(.reverseAppearance.opacity(0.7))
            }
            //splitter line
            Spacer()
            Rectangle()
                .frame(width:lineWidth,height:lineHeight)
                .foregroundStyle(.reverseAppearance)
                .opacity(0.5)
            Spacer()
            //Temp Stack
            VStack(alignment:.center){
                Text("Temp")
                    .foregroundStyle(.reverseAppearance.opacity(0.7))
                Text("\(temp, specifier: "%.0f")°C")
                    .font(.system(size: 32, weight: .medium, design: .rounded))
//                    .foregroundColor(.gray)
                    .foregroundStyle(.reverseAppearance.opacity(0.7))
            }
            //splitter line
            Spacer()
            Rectangle()
                .frame(width:lineWidth,height:lineHeight)
                .foregroundStyle(.reverseAppearance)
                .opacity(0.5)
            Spacer()
            //Vis Stack
            VStack(alignment:.center){
                Text("Visibility")
                    .foregroundStyle(.reverseAppearance.opacity(0.7))
                Text("\(vis, specifier: "%.0f")m")
                    .font(.system(size: 32, weight: .medium, design: .rounded))
//                    .foregroundColor(.gray)
                    .foregroundStyle(.reverseAppearance.opacity(0.7))
            }
            Spacer()
        }
    }
}

// MARK: - Preview
#Preview{
    ContentView()
}
