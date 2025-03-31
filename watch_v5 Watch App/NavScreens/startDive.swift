////
////  startDive.swift
////  watch_v5
////      emulates the "start workout" page that              Apple Watch typically uses and                 switches to DiveContainer
////  Created by Jack Skupien on 3/31/25.
////
//
//import SwiftUI
//
//struct StartDiveView: View {
//    @State private var isCountingDown = false
//    @State private var countdown = 3
//    @State private var showDiveView = false
//    
//    var body: some View {
//        Group {
//            if showDiveView {
//                DiveMetricsContainerView() // After countdown, show main dive view
//            } else {
//                VStack {
//                    if isCountingDown {
//                        Text("\(countdown)")
//                            .font(.system(size: 80, weight: .bold))
//                            .transition(.scale)
//                            .onAppear(perform: startCountdown)
//                    } else {
//                        Button(action: {
//                            isCountingDown = true
//                        }) {
//                            Text("Start Dive")
//                                .font(.title2)
//                                .padding()
//                                .background(Circle().fill(Color.blue).frame(width: 120, height: 120))
//                                .foregroundColor(.white)
//                        }
//                    }
//                }
//            }
//        }
//        .animation(.easeInOut, value: countdown)
//    }
//    
//    func startCountdown() {
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//            if countdown > 1 {
//                countdown -= 1
//            } else {
//                timer.invalidate()
//                showDiveView = true
//            }
//        }
//    }
//}
//
//#Preview {
//    StartDiveView()
//}
