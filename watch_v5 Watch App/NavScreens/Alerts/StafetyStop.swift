//
//  StafetyStop.swift
//  watch_v5
//
//  Created by Faith Chernowski on 3/31/25.
//
import SwiftUI

struct SafetyStop: View {
    @State private var timeRemaining = 181 // 3:01
    let depth = 15
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()

            VStack(spacing: 1) {
                Text("Safety Stop")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .minimumScaleFactor(0.5)
                Text("Required")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .minimumScaleFactor(0.5)

                VStack(spacing: 8) {
                    Text("Depth: \(depth) ft")
                    Text("Time Remaining:")
                    Text(formattedTime)
                }
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

                Spacer()

                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.black)
            }
            .padding()
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }

    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    SafetyStop()
}

