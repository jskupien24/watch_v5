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
    @StateObject private var compass = CompassManager()
    
    @State private var depth = "72 ft"
    @State private var waterTemp = "82°F"
//    @State private var heartRate = "76 BPM"
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var startTime: Date?
    @State private var isRunning = true

    var formattedTime: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60
        let milliseconds = Int((elapsedTime - floor(elapsedTime)) * 10) // Extract ms

        return String(format: "%02d:%02d:%02d.%d", hours, minutes, seconds, milliseconds)
    }

    
    func startTimer() {
        startTime = Date().addingTimeInterval(-elapsedTime)
        isRunning = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
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
                Text("Dive Time")
                    .font(.caption2)
                    .foregroundColor(.accent)
                    .padding(.top,-8)
                Text("\(formattedTime)")
                    .font(.title3)
                    .padding(.bottom, 4)
                    .monospaced()
                HStack {
                    VStack {
//                        Text("Heart Rate")
//                            .font(.caption2)
                        HStack{
                                Image(systemName: "suit.heart")
                                    .foregroundStyle(.accent)
                                    .symbolEffect(.pulse)
                                    .padding(.leading,-10)
                            Text("\(Int(manager.heartRate))")
                                .font(.title2)
                                .bold()
                        }
                    }
                    .padding(.trailing, 35)
                    VStack {
                        Text("Temp")
                            .font(.caption2)
                            .foregroundColor(.accent)
                        Text(waterTemp)
                            .font(.title2)
                            .bold()
                    }.padding(.trailing,0)
                }
                HStack{
                    VStack {
                        Text("Depth")
                            .font(.caption2)
                            .foregroundColor(.accent)
                        Text(depth)
                            .font(.title2)
                            .bold()
                    }
                    .padding(.trailing, 25)
                    VStack {
                        Text("Heading")
                            .font(.caption2)
                            .foregroundColor(.accent)
                        HStack{
                            Text("\(Int(compass.heading))º\(compass.direction)")
                                .font(.title2)
                                .bold()
//                                .strikethrough()
                        }
                    }
                }.padding(.vertical, 4)
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
