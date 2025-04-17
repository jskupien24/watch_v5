//
//  metrics.swift
//  watch_v5
//
//  Created by Faith Chernowski on 10/29/24.
//
//  Edited and built out by Jack Skupien on 03/31/25

import SwiftUI

struct DiveView: View {
    @EnvironmentObject var manager: HealthManager//for heart rate
    var body: some View{
        //page 1: Metrics
        ZStack{
            CompassView2()
            DiveMetricsView().environmentObject(manager)
                .navigationBarBackButtonHidden(true)
                .offset(y: 19.75)
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
    
    //grid
    let vOff=12.0//increase to move down
    let Hspace=130.0//increase to move apart
    let gridOpacity=0.5//opacity of grid
    let gridWidth=145.0
    
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
            Rectangle()
                .frame(width:gridWidth,height:1)
                .offset(y:-5)
                .foregroundStyle(.accent)
                .opacity(gridOpacity)
                .padding(EdgeInsets(top:-5, leading: 0, bottom: -5, trailing: 0))
            //STOPWATCH
            DiveStopWatch(formattedTime: formattedTime,progress: progress)
                .padding(.top,-2)
            
            //GRID
            VStack{
                Rectangle()
                    .frame(width:gridWidth,height:1)
                    .offset(y:vOff+3.5)
                    .foregroundStyle(.accent)
                    .opacity(gridOpacity)
                HStack(alignment: .lastTextBaseline){
                    //HEART RATE
                    HRView()
                    Spacer()
                    Rectangle()
                        .frame(width:1,height:60)
                        .offset(x:4,y:vOff)
                        .foregroundStyle(.accent)
                        .opacity(gridOpacity)
                    Spacer()
                    //TEMPERATURE
                    TempView()
                }
                .frame(maxWidth:Hspace, alignment: .center)
                .offset(x:4)
                Rectangle()
                    .frame(width:gridWidth,height:1)
                    .offset(y:vOff-16)
                    .foregroundStyle(.accent)
                    .opacity(gridOpacity)
            }.padding(EdgeInsets(top: -10, leading: 0, bottom: -25, trailing: 0))
            DepthView2()
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
            Image(systemName: "arrowtriangle.up")
                .foregroundStyle(.accent)
                .padding(EdgeInsets(top: -38, leading:0, bottom: 10, trailing:0))
                .scaleEffect(0.9)
            Text("\(Int(compass.heading))º\(compass.direction)")
                .font(.title3)
                .bold()
                .padding(EdgeInsets(top: -28, leading:0, bottom: 0, trailing:0))
                .fontDesign(.rounded)
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
            }.padding(-3)
        }
    }
}

//heart rate
struct HRView: View {
    @EnvironmentObject var manager: HealthManager
    var body: some View {
        VStack (alignment: .center){
            Text("BPM")
                .font(.caption2)
                .foregroundStyle(.accent)
//                .padding(.)
//            Spacer()
            HStack(alignment: .center) {//heart icon and rate
                Image(systemName: "suit.heart")
                    .foregroundStyle(.accent)
                    .symbolEffect(.pulse)
                    .padding(.leading,-10)
                (
                Text("\(Int(manager.heartRate))")
                    .font(.title2)
                    .bold()
                    .fontDesign(.rounded)
//                +
//                Text(" /min")
//                    .font(.caption2)
//                    .bold()
                )
            }
        }/*.padding(.vertical,3)*/
    }
}

//water temperature
struct TempView: View {
    @State var waterTemp: String = "83"
    var body: some View {
        VStack (alignment: .center) {//temp
            Text("Temp")
                .font(.caption2)
                .foregroundColor(.accent)
//                .fontDesign(.rounded)
                .padding(.bottom,-10)
            (
            Text(waterTemp)
                .font(.title2)
                .bold()
                .fontDesign(.rounded)
            +
            Text(" °F")
                .font(.caption2)
                .bold()
                .fontDesign(.rounded)
            )
        }
    }
}

//depth view (DEPRECATED by DepthView2 below
struct DepthView: View {
    private var depth="72"
    var body: some View {
        VStack {//depth
            Text("Depth")
                .font(.caption2)
                .foregroundColor(.accent)
            (
            Text(depth)
                .font(.title2)
                .bold()
            +
            Text(" ft")
                .font(.caption2)
                .bold()
            )
        }.padding(.vertical,1)
    }
}

//depth view
struct DepthView2: View {
    private var depth="72"
    var body: some View {
        VStack {//depth
//            Text("Depth")
//                .font(.caption2)
//                .foregroundColor(.accent)
            (
            Text(depth)
                .font(.system(size: 60, weight: .medium, design: .rounded))
//                .bold()
            +
            Text(" ft")
                .font(.caption2)
                .bold()
                .fontDesign(.rounded)
            ).offset(x: 5)
                .padding(.bottom,15)
        }//.padding(.top,-10)
    }
}

#Preview {
    DiveView().environmentObject(HealthManager())
}
