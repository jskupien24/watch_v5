//
//  MyDives.swift
//  watch_v5
//
//  Created by Jack Skupien on 2/3/25.
//

import SwiftUI

// Extended Dive model with more properties
struct Dive: Identifiable {
    let id = UUID()
    let date: Date
    let location: String
    let p_depth: Int
    let p_diveTime: Int
    let p_pctOxygen: Int
    let p_dcModel: NewDiveView.Model
    let bottomTime: Int
    let p_startPressure: Double
    let p_temp: Double
    let p_condNotes: String
    let notes: String
}

// Enum to track form sections
enum DiveFormSection: Int, CaseIterable {
    case basics = 0
    case oxygen
    case decompression
    case inert
    case gas
    case thermal
    case mission
    case logistics
    
    var title: String {
        switch self {
        case .basics: return "Basic Info"
        case .oxygen: return "Oxygen"
        case .decompression: return "Decompression"
        case .inert: return "Inert Gas Narcosis"
        case .gas: return "Gas Management"
        case .thermal: return "Thermal"
        case .mission: return "Mission"
        case .logistics: return "Logistics"
        }
    }
}

struct NewDiveView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var dives: [Dive]
    @State private var isEditing = false //changes color of slider value when editing
    
    // Form fields
    
    //basic
    @State private var date = Date()
    @State private var location = ""
    
    //o
    @State private var p_depth = 0
    @State private var p_diveTime = 0 //Make this a time
    @State private var p_pctOxygen = 0 //Make this a pct
    
    //d
    enum Model: String, CaseIterable, Identifiable {
        case Naui, Other
        var id: Self { self }
    }
    @State private var p_dcModel: Model = .Naui
    
    //i
    @State private var bottomTime = 0
    
    //g
    @State private var p_startPressure = 0.0
    
    //t
    @State private var p_condNotes = ""
    @State private var p_temp = 75.0
    
    //m
    @State private var notes = ""
    //l
    
    // Current section
    @State private var currentSection: DiveFormSection = .basics
    
    var body: some View {
        NavigationView {
            VStack {
                //Form Progress indicator
                ProgressView(value: Double(currentSection.rawValue), total: Double(DiveFormSection.allCases.count - 1))
                    .padding()
                
                //Form Section title
                Text("Section \(currentSection.rawValue + 1): \(currentSection.title)")
                    .font(.headline)
                    .padding(.bottom)
                
                //Form
                Form {
                    switch currentSection {
                    case .basics:
                        DatePicker("Date", selection: $date)
                        TextField("Location", text: $location)
                        
                    //Oxygen
                    case .oxygen:
                        Stepper("Planned Depth: \(Int(p_depth)) ft", value: $p_depth, in: 0...40)
                        Stepper("Planned Dive Time: \(Int(p_diveTime)) min", value: $p_diveTime, in: 0...40)
                        Stepper("Percent Oxygen: \(Int(p_pctOxygen))%", value: $p_pctOxygen, in: 0...40)
                       
                    //Decompression
                    case .decompression:
                        Picker("Decompression Model", selection: $p_dcModel){
                            Text("NAUI").tag(Model.Naui)
                            Text("PADI").tag(Model.Other)
                        }
                        //Show Dive Table
                        Image("DiveTableNAUI")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 350)
                            .foregroundStyle(.tint)
//                            .padding(EdgeInsets(top: 10, leading: 10, bottom:10, trailing: 5))
                        
                    //Inert Gas Narcosis
                    case .inert:
                        Stepper("Bottom Time: \(bottomTime) min", value: $bottomTime, in: 0...60)
                    
                    //Gas Management
                    case .gas:
                        Slider(value: $p_startPressure, in: 0...4350, step: 1,
                               onEditingChanged: { editing in
                                    isEditing = editing
                                }
                        )
                        Text("Starting Tank Pressure: \(Int(p_startPressure))")
                            .foregroundColor(isEditing ? .accentColor : .gray)
                        
                    //Thermal
                    case .thermal:
                        Slider(value: $p_startPressure, in: 33...100, step: 1,
                               onEditingChanged: { editing in
                                    isEditing = editing
                                }
                        )
                        Text("Expected Temperature: \(Int(p_startPressure))ºF")
                            .foregroundColor(isEditing ? .accentColor : .black)//changed from gray
                        
                        Spacer()
                        Text("Plan For Expected Conditions:")
                        TextField("Notes about water conditions here...", text: $p_condNotes).textFieldStyle(.roundedBorder)
                        
                    //Mission
                    case .mission:
                        TextEditor(text: $notes)
                            .frame(height: 100)
                        
                    //Logistics
                    case .logistics:
                        DatePicker("Date", selection: $date)
                        TextField("Location", text: $location)
                    }
                }
                
                // Navigation buttons
                HStack {
                    if currentSection.rawValue > 0 {
                        Button("Previous") {
                            withAnimation {
                                currentSection = DiveFormSection(rawValue: currentSection.rawValue - 1) ?? .basics
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if currentSection.rawValue < DiveFormSection.allCases.count - 1 {
                        Button("Next") {
                            withAnimation {
                                currentSection = DiveFormSection(rawValue: currentSection.rawValue + 1) ?? .logistics
                            }
                        }
                    } else {
                        Button("Save") {
                            let newDive = Dive(
                                //basic
                                date: date,
                                location: location,
                                //o
                                p_depth: p_depth,
                                p_diveTime: p_diveTime,
                                p_pctOxygen: p_pctOxygen,
                                //d
                                p_dcModel: p_dcModel,
                                //i
                                //g
                                //t
                                bottomTime: bottomTime,
                                p_startPressure: p_startPressure,
                                p_temp: p_temp,
                                p_condNotes: p_condNotes,
                                notes: notes
                            )
                            dives.append(newDive)
                            dismiss()
                        }
                        .disabled(location.isEmpty)
                    }
                }
                .padding()
            }
            .navigationTitle("Plan New Dive")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Update DiveRow to show more information
struct DiveRow: View {
    let dive: Dive
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(dive.location)
                .font(.headline)
            Text(dive.date.formatted(date: .long, time: .shortened))
                .font(.subheadline)
//            Text("Type: \(dive.diveType)")
//                .font(.subheadline)
//            Text("Depth: \(Int(dive.maxDepth))m • Time: \(dive.bottomTime)min")
//                .font(.subheadline)
//                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}

//// MyDivesView.swift
//struct Dive: Identifiable {
//    let id = UUID()
//    let date: Date
//    let location: String
//    // Add more dive properties as needed, such as:
//    // let depth: Double
//    // let duration: TimeInterval
//    // let waterTemperature: Double
//    // let visibility: Int
//}
//
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

//// DiveRow.swift
//struct DiveRow: View {
//    let dive: Dive
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(dive.location)
//                .font(.headline)
//            Text(dive.date.formatted(date: .long, time: .shortened))
//                .font(.subheadline)
//                .foregroundColor(.gray)
//        }
//        .padding(.vertical, 4)
//    }
//}
//
//// NewDiveView.swift
//struct NewDiveView: View {
//    @Environment(\.dismiss) private var dismiss
//    @Binding var dives: [Dive]
//    
//    @State private var date = Date()
//    @State private var location = ""
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                DatePicker("Date", selection: $date)
//                TextField("Location", text: $location)
//            }
//            .navigationTitle("Plan New Dive")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Save") {
//                        let newDive = Dive(date: date, location: location)
//                        dives.append(newDive)
//                        dismiss()
//                    }
//                    .disabled(location.isEmpty)
//                }
//            }
//        }
//    }
//}
