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
                .padding(.bottom, 0)
                .padding(.top,-20)
            //display modular compass bar
            CompassBar(heading: compass.heading)
                .frame(height: 31)
                .padding(.horizontal, 20)
//                .padding(.top,0)
            Image(systemName: "arrowtriangle.up.fill")
                .foregroundStyle(.accent)
                .padding(EdgeInsets(top: 0, leading:0, bottom: 10, trailing:0))
            //display heading
            Text(" \(Int(compass.heading))°")
                .font(.largeTitle)
                .fontWeight(.thin)
                .foregroundColor(.white)
                .padding(.bottom, -35)
                .padding(.top,-10)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    //convert degrees to direction (NW, SE, etc.)
    func direction(for degrees: Double) -> String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"]
        let index = Int((degrees + 22.5) / 45.0) % 8
        return directions[index]
    }
}

struct CompassBar: View {
    let heading: Double
    let totalTicks = 360
    let centerIndex = 180

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<totalTicks, id: \.self) { i in
                let tickAngle = (heading - Double(centerIndex * 10) + Double(i) * 10).truncatingRemainder(dividingBy: 360)
                let isHighlighted = abs(tickAngle) < 9.5
                    
                VStack{
                    Spacer()
                    Rectangle()
                        .frame(width: 4, height: (isHighlighted) ? 30 : 20) // Adjust width for better spacing
                        .foregroundColor(isHighlighted ? .red : .white.opacity(0.5))
                        .cornerRadius(2)
                }
                .padding(.bottom,5)
            }
        }
        .frame(maxWidth: 500, alignment: .center) // Extend fully
        .offset(x: -3) // Slight shift to center correctly
        .clipped() // Ensure no extra space
    }
}

#Preview {
    ModularCompassView()
}
