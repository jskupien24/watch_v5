//  ActivitiesPage.swift
//  watch_v5
//
//  Created by Faith Chernowski on 4/10/25.

import SwiftUI
import MapKit

struct DiveLogCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct DiveLogEntry: Identifiable {
    let id: UUID
    let date: String
    let duration: String
    let routeOverview: String
    let maxDepth: Int
    let averageHR: Int
    let averageSpeed: Double
    let oxygenUsed: String
    let depthData: [Int]
    let heartRateData: [Int]
    let coordinates: [DiveLogCoordinate]
}

struct ActivitiesPage: View {
    let completedDives: [DiveLogEntry] = [
        DiveLogEntry(
            id: UUID(),
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
                DiveLogCoordinate(coordinate: CLLocationCoordinate2D(latitude: 20.422, longitude: -86.922)),
                DiveLogCoordinate(coordinate: CLLocationCoordinate2D(latitude: 20.423, longitude: -86.923)),
                DiveLogCoordinate(coordinate: CLLocationCoordinate2D(latitude: 20.424, longitude: -86.924))
            ]
        ),
        DiveLogEntry(
            id: UUID(),
            date: "Mar 20, 2025",
            duration: "38m",
            routeOverview: "Shark Alley - Belize",
            maxDepth: 24,
            averageHR: 108,
            averageSpeed: 1.0,
            oxygenUsed: "990 psi",
            depthData: [6, 12, 22, 24, 20, 18, 10],
            heartRateData: [92, 97, 103, 110, 106, 102, 95],
            coordinates: [
                DiveLogCoordinate(coordinate: CLLocationCoordinate2D(latitude: 17.315, longitude: -87.534)),
                DiveLogCoordinate(coordinate: CLLocationCoordinate2D(latitude: 17.316, longitude: -87.536)),
                DiveLogCoordinate(coordinate: CLLocationCoordinate2D(latitude: 17.317, longitude: -87.538))
            ]
        )
    ]

    var body: some View {
        NavigationView {
            List(completedDives) { dive in
                if dive.routeOverview == "Coral Garden - Cozumel" {
                    NavigationLink(destination: CompletedDivesView()) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(dive.routeOverview)
                                .font(.headline)
                            Text("Date: \(dive.date) • Duration: \(dive.duration)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("Max Depth: \(dive.maxDepth)m")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .padding(.vertical, 8)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(dive.routeOverview)
                            .font(.headline)
                        Text("Date: \(dive.date) • Duration: \(dive.duration)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Max Depth: \(dive.maxDepth)m")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Activities")
        }
    }
}

struct ActivitiesPage_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesPage()
    }
}
