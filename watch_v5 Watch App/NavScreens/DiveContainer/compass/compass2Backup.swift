////
////  compass2Backup.swift
////  watch_v5
////
////  Created by Jack Skupien on 4/3/25.
////
//
////
////  Untitled.swift
////  watch_v5
////
////  Created by Jack Skupien on 4/03/25 (adapted from 3/03/25 version).
////
//
//import SwiftUI
//
//struct CompassView2: View {
//    @StateObject private var compass = CompassManager()
//    
//    var body: some View {
//        ZStack {
//            CompassNeedle2(angle: compass.heading)
//                .edgesIgnoringSafeArea(.all)
//                .frame(width: .infinity, height: .infinity)
//    //            .ignoresSafeArea()
//        }
//    }
////        .frame(maxWidth: .infinity, alignment: .center)
//}
//
//struct CompassNeedle2: View {
//    let angle: Double
//    
//    var body: some View {
//        let lineWidth=2.0
//        ZStack {
//            //NNE and SSW line
//            Rectangle()
//                .fill(Color.gray.opacity(0.5))
//                .frame(width: lineWidth-1.5, height: 250)
//                .offset(y:0)
//                .rotationEffect(.degrees(angle+22.5))
//            //ENE and ESE line
//            Rectangle()
//                .fill(Color.gray.opacity(0.5))
//                .frame(width: lineWidth-1.5, height: 250)
//                .offset(y:0)
//                .rotationEffect(.degrees(angle+67.5))
//            //NE and SW line
//            Rectangle()
//                .fill(Color.gray.opacity(0.5))
//                .frame(width: lineWidth-1.5, height: 250)
//                .offset(y:0)
//                .rotationEffect(.degrees(angle+112.5))
//            //NW and SE line
//            Rectangle()
//                .fill(Color.gray.opacity(0.5))
//                .frame(width: lineWidth-1.5, height: 250)
//                .offset(y:0)
//                .rotationEffect(.degrees(angle+157.5))
//            //rectangle covering quadrantals
//            RoundedRectangle(cornerRadius: 75)
//                .fill(.black)
//                .stroke(Color.gray.opacity(0.25), lineWidth: 1)
//                .frame(width: 195, height: 235)
//            
//            //quadrantal directions
//            //NE and SW line
//            Rectangle()
//                .fill(Color.gray)
//                .frame(width: lineWidth-1, height: 250)
//                .offset(y:0)
//                .rotationEffect(.degrees(angle+45))
//            //NW and SE line
//            Rectangle()
//                .fill(Color.gray)
//                .frame(width: lineWidth-1, height: 250)
//                .offset(y:0)
//                .rotationEffect(.degrees(angle+135))
//            
//            //rectangle covering quadrantals
//            RoundedRectangle(cornerRadius: 72.5)
//                .fill(.black)
//                .stroke(Color.gray.opacity(0.25), lineWidth: 1)
//                .frame(width: 187.5, height: 227.5)
//            
//            //cardinal directions
//            //North and south line
//            Rectangle()
//                .fill(Color.accent)
//                .frame(width: lineWidth, height: 250)
//                .offset(y:0)
//                .rotationEffect(.degrees(angle))
//            //east and west line
//            Rectangle()
//                .fill(Color.accent)
//                .frame(width: lineWidth, height: 250)
//                .offset(y:0)
//                .rotationEffect(.degrees(angle+90))
//            
//            //rectangle covering cardinals
//            RoundedRectangle(cornerRadius: 70)
//                .fill(.black)
//                .stroke(Color.accent.opacity(0.25), lineWidth: 1)
//                .frame(width: 180, height: 220)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Extend fully
//        .edgesIgnoringSafeArea(.all)
////                    .offset(x: -3) // Slight shift to center correctly
////            .clipped()
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
//#Preview {
//    CompassView2()
//}
