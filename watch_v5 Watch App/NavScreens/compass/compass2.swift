//
//  compass2.swift
//  watch_v5
//
//  Created by Jack Skupien on 3/24/25.
//

import SwiftUI

struct CompassViewETE: View {
    @StateObject private var compass = CompassManager()
    
    var body: some View {
        VStack {
            Text("\(Int(compass.heading))°")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            CompassNeedleETE(angle: compass.heading)
                .frame(width: 150, height: 150)
        }
    }
}

struct CompassNeedleETE: View {
    let angle: Double
    
    var body: some View {
        ZStack {
            //            Circle()
            //                .stroke(Color.gray, lineWidth: 2)
            //                .frame(width: 140, height: 140)
            
            Rectangle()
                .fill(Color.red)
                .frame(width: 4, height: 200)
            //                .offset(y: -30)
                .rotationEffect(.degrees(angle))
        }
        .frame(maxWidth: .infinity) //extend fully across screen
        .ignoresSafeArea()//ignore safe area constraints
        .clipped()
    }
}

#Preview {
    CompassViewETE()
}
