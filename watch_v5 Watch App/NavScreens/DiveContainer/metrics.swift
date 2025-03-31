//
//  metrics.swift
//  watch_v5
//
//  Created by Faith Chernowski on 10/29/24.
//
// Further edited and built out by Jack Skupien on 03/31/25

import SwiftUI


struct DiveMetricsView: View {
    @EnvironmentObject var manager: HealthManager
    @State private var depth = "72 ft"
    @State private var waterTemp = "82°F"
//    @State private var heartRate = "76 BPM"
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var startTime: Date?
    @State private var isRunning = true

    var formattedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    
    func startTimer() {
        startTime = Date().addingTimeInterval(-elapsedTime)
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let startTime = startTime {
                elapsedTime = Date().timeIntervalSince(startTime)
            }
        }
    }

    // Reset the timer if needed
    func resetTimer() {
        elapsedTime = 0
        startTime = nil
    }

    var body: some View {
        ScrollView {
            VStack {
                // Dive Metrics Section
//                Text("Dive Computer")
//                    .font(.caption)
//                    .padding(.top, -20)
//                    .padding(.bottom, 20)

                HStack {
                    VStack {
                        Text("Depth")
                            .font(.caption2)
                        Text(depth)
                            .font(.title2)
                            .bold()
                    }.padding(.trailing, 25)
                    VStack {
                        Text("Temp")
                            .font(.caption2)
                        Text(waterTemp)
                            .font(.title2)
                            .bold()
                    }
                }
                HStack{
                    VStack {
                        Text("Heart Rate")
                            .font(.caption2)
                        Text("\(Int(manager.heartRate))")
                            .font(.title2)
                            .bold()
                    }
                    .padding(.vertical, 4)
                }
//                Text("Heart Rate: \(Int(manager.heartRate))")
//                    .font(.body)
//                    .padding(.vertical, 2)
                Text("Dive Time: \(formattedTime)")
                    .font(.body)
                    .padding(.bottom, 4)
                // Compass Section
//                ModularCompassView()
//                    .padding(.top, 50)
            }
            .onAppear {
                startTimer()
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }
}

#Preview {
    DiveMetricsView().environmentObject(HealthManager())
}
