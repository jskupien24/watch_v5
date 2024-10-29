//
//  Alert.swift
//  watch_v5
//
//  Created by Fort Hunter on 10/29/24.
//
import SwiftUI

struct AlertPage: View {
    var body: some View {
        ZStack {
            Color.red // Set the background color
                .ignoresSafeArea() // Extends to edges of the screen
            Text("ALERT")
                .foregroundColor(Color.black)
                .bold()
                .font(.system(size: 50))
                
        }
    }
}
#Preview {
    AlertPage()
}
