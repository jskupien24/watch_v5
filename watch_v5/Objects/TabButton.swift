//
//  TabButton.swift
//  watch_v5
//
//  Created by Jack Skupien on 2/3/25.
//

/////////////////////
//DEPRECATED FILE ~Jack 2/3
//////////////////


//import SwiftUI
//
//struct TabButton: View {
//    var title: String
//    var icon: String
//    var index: Int
//    @Binding var selectedTab: Int
//    
//    @State private var pulse = false
//    
//    var body: some View {
//        Button(action: {
//            selectedTab = index
//            pulse.toggle()
//        }) {
//            VStack {
//                Image(systemName: icon)
//                    .font(.system(size: 24))
//                    .foregroundColor(selectedTab == index ? .accentColor : .gray)
//                    .symbolEffect(.bounce, options: .nonRepeating, value: pulse)
//                    .scaleEffect(pulse ? 1.2 : 1.0)
//                    .animation(.easeInOut(duration: 0.3), value: pulse)
//                
//                Text(title)
//                    .font(.caption)
//                    .foregroundColor(selectedTab == index ? .accentColor : .gray)
//            }
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
