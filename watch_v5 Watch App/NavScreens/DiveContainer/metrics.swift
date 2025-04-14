//
//  metrics.swift
//  watch_v5
//
//  Created by Faith Chernowski on 10/29/24.
//
// Further edited and built out by Jack Skupien on 03/31/25

import SwiftUI

struct DiveView: View {
    @EnvironmentObject var manager: HealthManager//for heart rate
    var body: some View{
        //page 1: Metrics
        ZStack{
            CompassView2()
            DiveMetricsView().environmentObject(manager)
                .navigationBarBackButtonHidden(true)
                .offset(y: 15)
                .scaleEffect(0.95)
        }
    }
}

struct DiveMetricsView: View {
    @EnvironmentObject var manager: HealthManager
    @StateObject private var compass = CompassManager()
    
    @State private var depth = "72 ft"
    @State private var waterTemp = "82°F"
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var startTime: Date?
    @State private var isRunning = true
    
    let totalDiveTime: TimeInterval = 10 * 60 // 10 minutes in seconds
    
    //grid spacing
    let columnPadding = 2.0
    let rowPadding = 2.0
    
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
    
    //elapsed time out of total
    var progress: Double {
        min(elapsedTime / totalDiveTime, 1.0)
    }

    var body: some View {
        VStack {//all 4 rows of title-data pairs
            
            //HEADING AND ARROW
            HeadingView()
            
            //STOPWATCH
            DiveStopWatch(formattedTime: formattedTime,progress: progress)
                .padding(0)
            
            //GRID
            HStack(alignment: .firstTextBaseline){
                //left column
                VStack{
                    //HEART RATE
                    HRView()
                    //DEPTH
                    DepthView()
                }.padding(.trailing, columnPadding)
                
                //RIGHT COLUMN
                VStack{
                    //TEMPERATURE
                    TempView()
                    //HEADING
                    VStack {//heading
                        Text("Heading")
                            .font(.caption2)
                            .foregroundColor(.accent)
                        HStack{
                            Text("\(Int(0))ºN").font(.title2).bold()
                        }
                    }.padding(.vertical,1)
                }.padding()
            }.frame(/*maxWidth: .infinity, */alignment: .center)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}



//heading and arrow
struct HeadingView: View {
    @StateObject private var compass = CompassManager()
    var body: some View {
        VStack{
            //show heading at top
            Image(systemName: "arrowtriangle.up.fill")
                .foregroundStyle(.accent)
                .padding(EdgeInsets(top: -45, leading:0, bottom: 10, trailing:0))
                .scaleEffect(1.1)
            Text("\(Int(0/*compass.heading*/))º\("N"/*compass.direction*/)")
                .font(.title3)
                .bold()
                .padding(EdgeInsets(top: -35, leading:0, bottom: 12, trailing:0))
        }
    }
}

struct DiveStopWatch: View {
    var formattedTime: String
    var progress: Double//val from 0.0 to 1.0
    
    var body: some View {
        VStack{
            //STOPWATCH ROW
            Text("Dive Time")
                .font(.caption2)
                .foregroundColor(.accent)
                .padding(.top,-8)
            Text("\(formattedTime)")
                .font(.title3)
                .padding(.bottom,0)
                .monospaced()
                .scaleEffect(1.15)
            ZStack{
                ProgressView(value: progress)
                    .progressViewStyle(.linear)
                    .tint(.accent)
                    .scaleEffect(x: 0.67, y: 0.5, anchor: .center)
    //                .padding([.leading, .trailing], 30)
                Rectangle()
                    .frame(width:2,height:7)
                    .offset(x: -24)
                    .foregroundColor(.black)
                Rectangle()
                    .frame(width:2,height:7)
                    .offset(x: 24)
                    .foregroundColor(.black)
            }
        }
    }
}

//heart rate
struct HRView: View {
    @EnvironmentObject var manager: HealthManager
    var body: some View {
        VStack{
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
        }
    }
}

//depth view
struct DepthView: View {
    private var depth="72 ft"
    var body: some View {
        VStack {//depth
            Text("Depth")
                .font(.caption2)
                .foregroundColor(.accent)
            Text(depth)
                .font(.title2)
                .bold()
        }.padding(.vertical,1)
    }
}


//water temperature
struct TempView: View {
    @State var waterTemp: String = "83ºF"
    var body: some View {
        VStack {//temp
            Text("Temp")
                .font(.caption2)
                .foregroundColor(.accent)
            Text(waterTemp)
                .font(.title2)
                .bold()
        }
    }
}

#Preview {
    DiveView().environmentObject(HealthManager())
}
