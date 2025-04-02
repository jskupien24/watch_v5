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
            //show heading at top
            Image(systemName: "arrowtriangle.up.fill")
                .foregroundStyle(.accent)
                .padding(EdgeInsets(top: -55, leading:0, bottom: 10, trailing:0))
            Text("\(Int(compass.heading))º\(compass.direction)")
                .font(.title3)
                .bold()
                .padding(EdgeInsets(top: -45, leading:0, bottom: 10, trailing:0))
            
            VStack {//all 3 rows of title-data pairs
                //dive time row
                Text("Dive Time")
                    .font(.caption2)
                    .foregroundColor(.accent)
                    .padding(.top,-8)
                Text("\(formattedTime)")
                    .font(.title3)
                    .padding(.bottom, 4)
                    .monospaced()
                HStack(alignment: .firstTextBaseline){//right and left columns
                    VStack{//left column
                        Text(" ").font(.caption2)
                        HStack(alignment: .center) {//heart icon and rate
                            Image(systemName: "suit.heart")
                                .foregroundStyle(.accent)
                                .symbolEffect(.pulse)
                                .padding(.leading,-10)
                            Text("\(Int(manager.heartRate))")
                                .font(.title2)
                                .bold()
                        }
//                            .padding(.trailing, 35)
                        VStack {//depth
                            Text("Depth")
                                .font(.caption2)
                                .foregroundColor(.accent)
                            Text(depth)
                                .font(.title2)
                                .bold()
                        }
//                        .padding(.trailing, 25)
                    }/*.padding(.trailing, 35)*/
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer().frame(maxWidth: 10)
                    VStack{//right column
                        VStack {//temp
                            Text("Temp")
                                .font(.caption2)
                                .foregroundColor(.accent)
                            Text(waterTemp)
                                .font(.title2)
                                .bold()
                        }
//                        .padding(.trailing,0)
                        VStack {//heading
                            Text("Heading")
                                .font(.caption2)
                                .foregroundColor(.accent)
                            HStack{
                                Text("\(Int(0))ºN").font(.title2).bold()
//                                Text("\(Int(compass.heading))º\(compass.direction)")
//                                    .font(.title2)
//                                    .bold()
    //                                .strikethrough()
                            }
                        }
                    }
                    .frame(/*minWidth: 100, */maxWidth: .infinity, alignment: .trailing)
//                    .padding(.vertical, 4)
                }.frame(maxWidth: .infinity, alignment: .center) // Extend fully
//                    .offset(x: -3) // Slight shift to center correctly
                    .clipped() // Ensure no extra space
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
