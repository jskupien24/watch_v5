//
//  Untitled.swift
//  watch_v5
//
//  Created by Jack Skupien on 3/24/25 (adapted from 3/03/25 version).
//

import SwiftUI

struct CompassView: View {
    @StateObject private var compass = CompassManager()
    
    var body: some View {
        VStack {
            Text("\(Int(compass.heading))°")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            CompassNeedle(angle: compass.heading)
                .frame(width: 150, height: 150)
        }
    }
}

struct CompassNeedle: View {
    let angle: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray, lineWidth: 2)
                .frame(width: 140, height: 140)
            
            Rectangle()
                .fill(Color.red)
                .frame(width: 4, height: 60)
                .offset(y: -30)
                .rotationEffect(.degrees(angle))
        }
    }
}

#Preview {
    CompassView()
}
