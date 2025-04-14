//  CompletedDivesView.swift
//  watch_v5
//
//  Created by Faith Chernowski on 4/10/25.

import SwiftUI
import Charts
import MapKit

struct CompletedDivesView: View {
    let completedDives: [DiveActivity] = [
        DiveActivity(
            date: "Apr 1, 2025",
            duration: "45m",
            routeOverview: "Coral Garden - Cozumel",
            maxDepth: 28,
            averageHR: 110,
            averageSpeed: 1.2,
            oxygenUsed: "1200 psi",
            depthData: [5, 10, 20, 28, 22, 15, 10],
            heartRateData: [95, 105, 110, 120, 115, 110, 100],
            coordinates: [
                DiveCoordinate(coordinate: CLLocationCoordinate2D(latitude: 20.422, longitude: -86.922)),
                DiveCoordinate(coordinate: CLLocationCoordinate2D(latitude: 20.423, longitude: -86.923)),
                DiveCoordinate(coordinate: CLLocationCoordinate2D(latitude: 20.424, longitude: -86.924))
            ]
        )
    ]

    var body: some View {
        NavigationView {
            if let dive = completedDives.first {
                CompletedDiveDetailView(dive: dive)
                    .navigationBarTitle("Dive Summary", displayMode: .inline)
            } else {
                Text("No dive data available.")
                    .foregroundColor(.gray)
            }
        }
    }
}

struct CompletedDiveDetailView: View {
    let dive: DiveActivity
    @State private var region: MKCoordinateRegion

    init(dive: DiveActivity) {
        self.dive = dive
        let center = dive.coordinates.first?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        _region = State(initialValue: MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                        .frame(height: 220)
                        .edgesIgnoringSafeArea(.top)

                    VStack {
                        Image(systemName: "waveform.path.ecg")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)

                        Text(dive.routeOverview)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)

                        Text("Date: \(dive.date) | Duration: \(dive.duration)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }

                VStack(spacing: 10) {
                    Text("Max Depth: \(dive.maxDepth)m")
                    Text("Avg Heart Rate: \(dive.averageHR) bpm")
                    Text("Avg Speed: \(String(format: "%.1f", dive.averageSpeed)) m/s")
                    Text("Oxygen Used: \(dive.oxygenUsed)")
                }
                .font(.subheadline)
                .padding()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Route Map")
                        .font(.headline)

                    Map(coordinateRegion: $region, annotationItems: dive.coordinates) { point in
                        MapMarker(coordinate: point.coordinate, tint: .blue)
                    }
                    .frame(height: 200)
                    .cornerRadius(12)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Depth Over Time")
                        .font(.headline)

                    Chart {
                        ForEach(dive.depthData.indices, id: \.self) { i in
                            LineMark(
                                x: .value("Minute", i),
                                y: .value("Depth (m)", dive.depthData[i])
                            )
                            .interpolationMethod(.monotone)
                            .foregroundStyle(Color.blue)
                        }
                    }
                    .frame(height: 200)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Heart Rate Over Time")
                        .font(.headline)

                    Chart {
                        ForEach(dive.heartRateData.indices, id: \.self) { i in
                            LineMark(
                                x: .value("Minute", i),
                                y: .value("BPM", dive.heartRateData[i])
                            )
                            .interpolationMethod(.monotone)
                            .foregroundStyle(Color.red)
                        }
                    }
                    .frame(height: 200)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct DiveCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct DiveActivity: Identifiable {
    let id = UUID()
    let date: String
    let duration: String
    let routeOverview: String
    let maxDepth: Int
    let averageHR: Int
    let averageSpeed: Double
    let oxygenUsed: String
    let depthData: [Int]
    let heartRateData: [Int]
    let coordinates: [DiveCoordinate]
}

struct CompletedDivesView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedDivesView()
    }
}
