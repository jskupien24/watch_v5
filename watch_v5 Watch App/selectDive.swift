//
//  selectDive.swift
//  watch_v5
//
//  Created by Fort Hunter on 11/12/24
//
import SwiftUI

struct Dive: Identifiable {
    var id = UUID()
    var name: String
}

var dives = [Dive(name: "Planned Dives"),
             Dive(name: "Unplanned Dive"),
             Dive(name: "Snorkle"),
             Dive(name:"Free Dive")]

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
                        NavigationLink(destination: WorkoutPage()){
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
    struct selectDive_Previews: PreviewProvider {
        static var previews: some View {
            selectDive()
        }
    }

