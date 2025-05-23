//
//  LoadingScreen.swift
//  watch_v5
//
//  Created by Jack Skupien on 2/3/25.
//

import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        VStack {//vertical stack container
            //add dd flag image
            Image("flag")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundStyle(.tint)
            //add text
            Text("Hello, Diver!")
                .bold()
                .font(.system(size: 32))
                .frame(width: 200)
        }
    }
}

#Preview {
    LoadingScreen()
}
