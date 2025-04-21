//
//  startDive.swift
//  watch_v5
//      emulates the "start workout" page that              Apple Watch typically uses and                 switches to DiveContainer
//  Created by Jack Skupien on 3/31/25.
//

import SwiftUI

struct StartDiveView: View {
    @EnvironmentObject var manager: HealthManager
    @State private var isCountingDown = false
    @State private var countdown: Int = 3
    @State private var showDiveView = false
    @State private var scaleEffect: CGFloat = 1.0
    @State private var opacity: CGFloat = 1.0
    
    var body: some View {
        Group {
            if showDiveView {
                DiveContainerView().environmentObject(manager) // Show dive view after countdown
            } else {
                VStack(alignment: .center) {
                    if isCountingDown {
                        CountdownView(countdown: countdown, scaleEffect: scaleEffect, opacity: opacity)
                            .onAppear(perform: startCountdown)
                    } else {
                        HStack{
                            Spacer()
                            Text("Reef Dive #1")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.bottom, 25)
//                                    .padding(.leading, -30)
                            Spacer()
                        }
                        
                        Button(action: {
                            isCountingDown = true
                        }) {
//                            Label("   Start Dive",
//                                  systemImage: "play.fill")
//                            .foregroundStyle(.white.opacity(0.9))
                            HStack{
                                Image(systemName: "play.fill")
                                    .offset(x: -10)
                                    .foregroundStyle(.white.opacity(0.75))
//                                    .padding(.leading,0)
//                                Spacer()
                                Text("Start Dive")
                                    .foregroundStyle(.white.opacity(0.75))
                            }
                        }
                        .foregroundStyle(.blue)
                    }
                }
            }
        }
    }
    
    func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdown > 0 {
                withAnimation(.bouncy(duration: 0.3)) {
                        scaleEffect = 1.5
                        opacity = 1
                    }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation(.easeOut(duration: 0.3)) {
                                scaleEffect = 1.0
                                opacity = 0.5
                            }
                    }
                countdown -= 1
            } else {
                timer.invalidate()
                showDiveView = true
            }
        }
    }
}

struct CountdownView: View {
    var countdown: Int
    var scaleEffect: CGFloat
    var opacity: CGFloat

    var body: some View {
        ZStack {
            if(countdown>0){
                Text("\(countdown)")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(scaleEffect)
                    .opacity(opacity)
            } else {
                Text("Go!")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(scaleEffect)
                    .opacity(opacity)
            }
            Circle()
                .stroke(lineWidth: 15)
                .foregroundColor(.gray.opacity(0.5))
                .padding(10)
            
            Circle()
                .trim(from: 0, to: CGFloat(countdown) / 3.0)
                .stroke(style: StrokeStyle(lineWidth: 13, lineCap: .round, lineJoin: .round))
                .rotation(Angle(degrees: -90))
                .foregroundColor(.green)
                .padding(10)
                .animation(.easeInOut(duration: 0.3), value: countdown) // Smooth circle update
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

//#Preview {
//    StartDiveView().environmentObject(HealthManager())
//}

#Preview{
    StartDiveView()
}
