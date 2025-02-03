//
//  Homeview2.swift
//  watch_v5
//
//  Created by Faith Chernowski on 2/3/25.
//
import SwiftUI
struct DiveCardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "map")
                    .foregroundColor(.blue)
                Text("Great Barrier Reef")
                    .font(.headline)
            }
            
            HStack {
                Image(systemName: "clock")
                Text("45 min")
                Spacer()
                Image(systemName: "arrow.down.to.line")
                Text("30m")
            }
            .font(.subheadline)
            .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 2))
        .padding(.horizontal)
    }
}

#Preview {
    DiveCardView()
}

