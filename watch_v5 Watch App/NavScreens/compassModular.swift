//
//  compassModular.swift
//  watch_v5
//
//  Created by Jack Skupien on 3/24/25.
//
import SwiftUI
import CoreLocation

struct ModularCompassView: View {
    @StateObject private var compass = CompassManager()
    
    var body: some View {
        VStack {
            //display direction
            Text("\(direction(for: compass.heading))")
//                .font(.largeTitle)
                .font(.system(size: 72, weight: .light, design: .default))
                .fontWeight(.thin)
                .foregroundColor(.white)
//                .monospaced()
                .padding(.bottom, 20)
                .padding(.top,-20)
            //display modular compass bar
            CompassBar(heading: compass.heading)
                .frame(height: 40)
                .padding(.horizontal, 20)
            //display heading
            Text(" \(Int(compass.heading))°")
                .font(.largeTitle)
                .fontWeight(.thin)
                .foregroundColor(.white)
                .padding(.bottom, -20)
                .padding(.top,-10)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    // Convert degrees into cardinal direction (NW, SE, etc.)
    func direction(for degrees: Double) -> String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"]
        let index = Int((degrees + 22.5) / 45.0) % 8
        return directions[index]
    }
}

// MARK: - Compass Bar UI
struct CompassBar: View {
    let heading: Double
    let totalTicks = 36  // Total tick marks in the bar

    var body: some View {
        GeometryReader { geo in
            let tickWidth = geo.size.width / CGFloat(totalTicks)
            
            HStack(spacing: 2) {
                ForEach(0..<totalTicks, id: \.self) { i in
                    let tickAngle = Double(i) * (360.0 / Double(totalTicks))
                    let isHighlighted = abs(heading - tickAngle) < 15
                    
                    Rectangle()
                        .frame(width: tickWidth, height: isHighlighted ? 30 : 20)
                        .foregroundColor(isHighlighted ? .accentColor : .white.opacity(0.5))
                        .cornerRadius(2)
                }
            }
        }
    }
}


#Preview {
    ModularCompassView()
}
