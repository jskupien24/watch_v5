//
//  metrics.swift
//  watch_v5
//
//  Created by Faith Chernowski on 10/29/24.
//
import SwiftUI

struct DiveMetricsView: View {
    @State private var depth = "72 ft"
    @State private var waterTemp = "82°F"
    @State private var heartRate = "76 BPM"
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var startTime: Date?
    @State private var isRunning = true  // Automatically start the timer

    var formattedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Automatically start the timer when the view appears
    func startTimer() {
        startTime = Date().addingTimeInterval(-elapsedTime) // Continue from last elapsed time
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
        VStack {
            Text("Dive Computer")
                .font(.caption)
                .padding(.top, 4)

            HStack {
                VStack {
                    Text("Depth")
                        .font(.caption2)
                    Text(depth)
                        .font(.title2)
                        .bold()
                }
                VStack {
                    Text("Temp")
                        .font(.caption2)
                    Text(waterTemp)
                        .font(.title2)
                        .bold()
                }
            }
            .padding(.vertical, 4)

            Text("Heart Rate: \(heartRate)")
                .font(.body)
                .padding(.vertical, 2)

            Text("Dive Time: \(formattedTime)")
                .font(.body)
                .padding(.bottom, 4)
        }
        .onAppear {
            startTimer()  // Start the timer as soon as the view appears
        }
        .onDisappear {
            timer?.invalidate()  // Stop the timer when the view disappears
        }
        .padding()
    }
}

#Preview {
    DiveMetricsView()
}
