//
//  Untitled.swift
//  watch_v5
//  SEE LINE 14 BEFORE BUILDING OR TESTING-- THE CANVAS'S Y OFFSET IS NOT THE SAME AS THE WATCH'S Y OFFSET
//  Created by Jack Skupien on 4/03/25 (adapted from 3/03/25 version).
//

import SwiftUI

struct CompassView2: View {
    @StateObject private var compass = CompassManager()
    
    var body: some View {
        let t=true//set to true if testing, false if building
        ZStack {
            //uncomment below block to see white edge safespace
            /*
            if(t){
                Color.white
                    .edgesIgnoringSafeArea(.all)
            }
             */
            CompassNeedle2(angle: compass.heading,testing: t)
                .edgesIgnoringSafeArea(.all)
                .frame(width: .infinity, height: .infinity)
    //            .ignoresSafeArea()
        }
    }
//        .frame(maxWidth: .infinity, alignment: .center)
}

struct CompassNeedle2: View {
    let angle: Double
    let testing: Bool
    
    var body: some View {
        //testing bool
        let vOffset=(testing ? -8.25 : -3.5)
        //direction line constants
        let lineWidth=2.0
        let lineHeight=300.0
        //center cover constants
        let frameWidth=176.5//previously 183.0
        let frameHeight=222.0
        let frameCRadius=41.0//previously 40.0
        ZStack {
            //octal directions
            //NNE/SSW line
            Rectangle()
                .fill(Color.accent.opacity(0.5))
                .frame(width: lineWidth-1, height: lineHeight)
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
                .frame(width: lineWidth-1, height: lineHeight)
                .offset(y:0)
                .rotationEffect(.degrees(-1*(angle+157.5)))
            //SSE/NNE line
            Rectangle()
                .fill(Color.accent.opacity(0.5))
                .frame(width: lineWidth-1, height: lineHeight)
                .offset(y:0)
                .rotationEffect(.degrees(-1*(angle+67.5)))
            //rectangle covering octals
            RoundedRectangle(cornerRadius: frameCRadius+12)
                .fill(.black)
//                .stroke(Color.accent.opacity(0.25), lineWidth: 1)
                .frame(width: frameWidth+22, height: frameHeight+22)
            
            //quadrantal directions
            //NE/SW line
            Rectangle()
                .fill(Color.accent.opacity(0.5))
                .frame(width: lineWidth-0.5, height: lineHeight)
                .offset(y:0)
                .rotationEffect(.degrees(-1*(angle+45)))
            //SE/NW line
            Rectangle()
                .fill(Color.accent.opacity(0.5))
                .frame(width: lineWidth-0.5, height: lineHeight)
                .offset(y:0)
                .rotationEffect(.degrees(-1*(angle+135)))
            //rectangle covering cardinals
            RoundedRectangle(cornerRadius: frameCRadius+5)
                .fill(.black)
//                .stroke(Color.accent.opacity(0.25), lineWidth: 1)
                .frame(width: frameWidth+11, height: frameHeight+11)
            
            
            //cardinal directions
            //North and south line
            Rectangle()
                .fill(Color.accent.opacity(1))
                .frame(width: lineWidth, height: lineHeight)
                .offset(y:0)
                .rotationEffect(.degrees(-1*angle))
            //east and west line
            Rectangle()
                .fill(Color.accent.opacity(1))
                .frame(width: lineWidth, height: lineHeight)
                .offset(y:0)
                .rotationEffect(.degrees(-1*angle+90))
            //rectangle covering cardinals
            RoundedRectangle(cornerRadius: frameCRadius)
                .fill(.black)
//                .stroke(Color.accent.opacity(0.25), lineWidth: 1)
                .frame(width: frameWidth, height: frameHeight)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Extend fully
        .offset(y:vOffset)
        .edgesIgnoringSafeArea(.all)

//            .clipped()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CompassView2()
}
