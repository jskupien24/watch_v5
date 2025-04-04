//
//  Untitled.swift
//  watch_v5
//  SEE LINE 105 BEFORE BUILDING-- THE CANVAS'S Y OFFSET IS NOT THE SAME AS THE WATCH'S Y OFFSET
//  Created by Jack Skupien on 4/03/25 (adapted from 3/03/25 version).
//

import SwiftUI

struct CompassView2: View {
    @StateObject private var compass = CompassManager()
    
    var body: some View {
        ZStack {
//            Color.white
//                .edgesIgnoringSafeArea(.all)
            CompassNeedle2(angle: compass.heading)
                .edgesIgnoringSafeArea(.all)
                .frame(width: .infinity, height: .infinity)
    //            .ignoresSafeArea()
        }
    }
//        .frame(maxWidth: .infinity, alignment: .center)
}

struct CompassNeedle2: View {
    let angle: Double
    
    var body: some View {
        let lineWidth=2.0
        let lineHeight=300.0
        ZStack {
            //octal directions
            //NNE/SSW line
            Rectangle()
                .fill(Color.accent.opacity(0.5))
                .frame(width: lineWidth-1, height: 300)
                .offset(y:0)
                .rotationEffect(.degrees(-1*(angle+22.5)))
            //ESE/WNW line
            Rectangle()
                .fill(Color.accent.opacity(0.5))
                .frame(width: lineWidth-1, height: lineHeight)
                .offset(y:0)
                .rotationEffect(.degrees(-1*(angle+112.5)))
            //ESE/WSW line
            Rectangle()
                .fill(Color.accent.opacity(0.5))
                .frame(width: lineWidth-1, height: 300)
                .offset(y:0)
                .rotationEffect(.degrees(-1*(angle+157.5)))
            //SSE/NNE line
            Rectangle()
                .fill(Color.accent.opacity(0.5))
                .frame(width: lineWidth-1, height: lineHeight)
                .offset(y:0)
                .rotationEffect(.degrees(-1*(angle+67.5)))
            //rectangle covering octals
            RoundedRectangle(cornerRadius: 52)
                .fill(.black)
//                .stroke(Color.accent.opacity(0.25), lineWidth: 1)
                .frame(width: 205, height: 244)
            
            //quadrantal directions
            //NE/SW line
            Rectangle()
                .fill(Color.accent.opacity(0.5))
                .frame(width: lineWidth-0.5, height: 300)
                .offset(y:0)
                .rotationEffect(.degrees(-1*(angle+45)))
            //SE/NW line
            Rectangle()
                .fill(Color.accent.opacity(0.5))
                .frame(width: lineWidth-0.5, height: lineHeight)
                .offset(y:0)
                .rotationEffect(.degrees(-1*(angle+135)))
            //rectangle covering cardinals
            RoundedRectangle(cornerRadius: 45)
                .fill(.black)
//                .stroke(Color.accent.opacity(0.25), lineWidth: 1)
                .frame(width: 194, height: 233)
            
            
            //cardinal directions
            //North and south line
            Rectangle()
                .fill(Color.accent.opacity(1))
                .frame(width: lineWidth, height: 300)
                .offset(y:0)
                .rotationEffect(.degrees(-1*angle))
            //east and west line
            Rectangle()
                .fill(Color.accent.opacity(1))
                .frame(width: lineWidth, height: lineHeight)
                .offset(y:0)
                .rotationEffect(.degrees(-1*angle+90))
            //rectangle covering cardinals
            RoundedRectangle(cornerRadius: 40)
                .fill(.black)
//                .stroke(Color.accent.opacity(0.25), lineWidth: 1)
                .frame(width: 183, height: 222)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Extend fully
        .offset(y:-8.5)
//        .offset(y:-3.5)///////uncomment when building to watch
        .edgesIgnoringSafeArea(.all)

            .clipped()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CompassView2()
}
