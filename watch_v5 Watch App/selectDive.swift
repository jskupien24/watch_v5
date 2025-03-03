//
//  selectDive.swift
//  watch_v5
//
//  Created by Fort Hunter on 11/12/24
//  Continued by Jack Skupien on 02/24/25

import SwiftUI

struct Dive: Identifiable {
    var id = UUID()
    var name: String
}

var dives = [Dive(name: "Planned Dives"),
             Dive(name: "Unplanned Dive"),
             Dive(name: "Snorkel"),
             Dive(name:"Free Dive")]

struct FadeView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView(showSplash: $showSplash)
            } else {
                selectDive()
            }
        }
    }
}

struct SplashView: View {
    @Binding var showSplash: Bool
    @State private var opacity = 2.0

    var body: some View {
        Text("Hello, Diver")
            .font(.largeTitle)
            .fontWeight(.bold)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 2.0)) {
                    opacity = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        showSplash = false
                    }
                }
            }
    }
}

struct selectDive: View{
    var body: some View{
        NavigationStack{
            VStack(alignment: .leading) {
                Text("Select a Dive")
                    .font(.body)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, -15)
                    .frame(maxWidth: .infinity, alignment: .center)
                List {
                    ForEach(dives){dive in
                        NavigationLink(destination: WorkoutPage().environment(manager)){
                            Button(action: {
                                // Handle the button tap here
                                print(dive.name)
                            }) {
                                Text(dive.name)
                                    .padding()
                                    .foregroundColor(.blue) // Change color if you like
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                }
            }
        }
    }
}
    struct FadeView_Previews: PreviewProvider {
        static var previews: some View {
            FadeView()
        }
    }

