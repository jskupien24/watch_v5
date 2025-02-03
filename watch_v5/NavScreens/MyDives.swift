//
//  MyDives.swift
//  watch_v5
//
//  Created by Jack Skupien on 2/3/25.
//

import SwiftUI

// MyDivesView.swift
struct Dive: Identifiable {
    let id = UUID()
    let date: Date
    let location: String
    // Add more dive properties as needed, such as:
    // let depth: Double
    // let duration: TimeInterval
    // let waterTemperature: Double
    // let visibility: Int
}

// MyDivesView.swift
struct MyDivesView: View {
    @State private var dives: [Dive] = []
    @State private var showingNewDiveSheet = false
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            VStack {
                if dives.isEmpty {
                    ContentUnavailableView(
                        "No Dives Yet",
                        systemImage: "water.waves",
                        description: Text("Press '+' to plan your first dive!")
                    )
                } else {
                    List {
                        ForEach(dives) { dive in
                            DiveRow(dive: dive)
                        }
                        .onDelete(perform: deleteDives)
                    }
                }
            }
            .navigationTitle("My Dives")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showingNewDiveSheet = true
                    }) {
                        Label("Plan a New Dive", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewDiveSheet) {
                NewDiveView(dives: $dives)
            }
        }
    }
    
    private func deleteDives(at offsets: IndexSet) {
        dives.remove(atOffsets: offsets)
    }
}

// DiveRow.swift
struct DiveRow: View {
    let dive: Dive
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(dive.location)
                .font(.headline)
            Text(dive.date.formatted(date: .long, time: .shortened))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}

// NewDiveView.swift
struct NewDiveView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var dives: [Dive]
    
    @State private var date = Date()
    @State private var location = ""
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date", selection: $date)
                TextField("Location", text: $location)
            }
            .navigationTitle("Plan New Dive")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newDive = Dive(date: date, location: location)
                        dives.append(newDive)
                        dismiss()
                    }
                    .disabled(location.isEmpty)
                }
            }
        }
    }
}

//struct MyDivesView: View {
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("My Dives Content")
//                    .font(.largeTitle)
//                    .padding()
//                
//                Spacer()
//            }
//            .navigationTitle("My Dives")
//        }
//    }
//}
