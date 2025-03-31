//
//  OffCourse.swift
//  watch_v5
//
//  Created by Faith Chernowski on 3/31/25.
//

import SwiftUI

struct OffCourse: View {
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("OFF COURSE WARNING")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                Text("Return to course or return to surface")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                Spacer()
                
                HStack {
                    // Green Arrow (Simple triangle approximation)
                    Triangle()
                        .fill(Color.green)
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(250))
                        .padding(.leading, 20)

                    Spacer()

                    VStack(alignment: .trailing, spacing: 5) {
                        Image(systemName: "ferry.fill") // or "ferry" / custom asset
                            .resizable()
                            .frame(width: 30, height: 20)
                            .foregroundColor(.black)

                        Image(systemName: "triangle.fill")
                            .resizable()
                            .frame(width: 8, height: 8)
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 20)
                }
            }
            .padding(.top, 40)
        }
    }
}

// Simple triangle shape for the green arrow
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY)) // top
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // bottom right
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // bottom left
        path.closeSubpath()
        return path
    }
}

#Preview {
    OffCourse()
        .frame(width: 200, height: 250) // Simulate Apple Watch
}

