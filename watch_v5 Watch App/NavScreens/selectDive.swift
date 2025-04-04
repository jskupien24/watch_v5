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
             Dive(name: "Free Dive")]

var comp = Dive(name: "Compass")
var modComp = Dive (name: "Modular Compass")

var tmp=Dive(name: "send to phone")

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
    @EnvironmentObject var manager: HealthManager
    @StateObject var watchConnector = WatchToIOSConnector()
    
    func sendToPhone(){
        watchConnector.sendDataToPhone()
    }
    var body: some View{
        NavigationStack{
            VStack(alignment: .leading) {
                Text("Select a Dive")
                    .font(.title3)
                    .fontWeight(.bold)
//                    .foregroundStyle(.accent)
                    .multilineTextAlignment(.center)
//                    .padding(.top, -15)
                    .padding(EdgeInsets(top: -8, leading: 0, bottom:10, trailing: 0))
                    .frame(maxWidth: .infinity, alignment: .center)
                List {
                    ForEach(dives){ dive in
                        NavigationLink(destination:/*DiveContainerView()*/StartDiveView().environmentObject(manager)){
                            Button(action: {
                                sendToPhone()
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
                    //compass button
                    NavigationLink(destination: CompassView2()){
                        Button(action: {
                            // Handle the button tap here
                            print(comp.name)
                        }) {
                            Text(comp.name)
                                .padding()
                                .foregroundColor(.accentColor) // Change color if you like
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    //mod compass button
                    NavigationLink(destination: ModularCompassView()){
                        Button(action: {
                            // Handle the button tap here
                            print(modComp.name)
                        }) {
                            Text(modComp.name)
                                .padding()
                                .foregroundColor(.accentColor) // Change color if you like
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    Button(action: sendToPhone) {
                                        Text("Send Test Message")
                                            .font(.headline)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 10)
                }
            }
        }
    }
}
    struct FadeView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView().environmentObject(HealthManager())
        }
    }

