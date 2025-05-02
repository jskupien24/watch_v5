//
//  MyDives.swift
//  watch_v5
//
//  Created by Jack Skupien on 2/3/25.
//

import FirebaseDatabase
import FirebaseAuth
import SwiftUI

// Extended Dive model with more properties
struct Dive: Identifiable {
    let id = UUID()
    let date: Date
    let location: String
    let p_depth: Double
    let p_diveTime: Double
    let p_pctOxygen: Double
    let p_dcModel: NewDiveView.Model
    let p_sGroup: NewDiveView.Group
    let p_eGroup: NewDiveView.Group
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
    @StateObject private var watchConnector = WatchConnector()
    
    //BuhlmannCalculator stuff
    @StateObject private var calculator = BuhlmannCalculator()
    @State private var diveResults: DiveResults?
    
    
    private var safetyStatus: String {
        guard let results = diveResults else { return "" }
        
        // Convert input depth to meters for comparison
        let depthInMeters = Double(p_depth) * 0.3048
        if depthInMeters > results.mod {
            return "⚠️ Exceeds Maximum Operating Depth!"
        }
        if !results.isWithinLimits {
            return "⚠️ Decompression Required"
        }
        return "✅ Within No-Decompression Limits"
    }
    
    private func updateDiveCalculations() {
        // Convert feet to meters for calculator
        let depthInMeters = Double(p_depth) * 0.3048
        diveResults = calculator.calculateRecreationalLimits(
            depth: depthInMeters,
            time: p_diveTime,
            o2Percentage: Double(p_pctOxygen)
        )
    }
    
    
    
    func convertDiveToDict(dive: Dive) -> [String: Any] {
        let dateFormatter = ISO8601DateFormatter()
        var newp_dcModel = "Naui"
        if dive.p_dcModel == Model.Naui{
            newp_dcModel = "Naui"
        }
        else{
            newp_dcModel = "Padi"
        }
        var newp_sGroup = ".A"
        var newp_eGroup = ".A"
                
        return [
            "id": dive.id.uuidString,
            "date": dateFormatter.string(from: dive.date),
            "location": dive.location,
            "p_depth": dive.p_depth,
            "p_diveTime": dive.p_diveTime,
            "p_pctOxygen": dive.p_pctOxygen,
            "p_dcModel": newp_dcModel,
            "p_sGroup": newp_sGroup,
            "p_eGroup": newp_eGroup,
            "bottomTime": dive.bottomTime,
            "p_startPressure": dive.p_startPressure,
            "p_temp": dive.p_temp,
            "p_condNotes": dive.p_condNotes,
            "notes": dive.notes
        ]
    }
    
//    func getThermalRecommendation(temp: Double, diveTime: Double) -> Int {
//        switch temp {
//        case 92...:
//            return 0//"No wetsuit required"
//        case 85...:
//            return diveTime > 30 ? 1 : 2 //"Shorty Wetsuit (2mm-3mm)" : "No wetsuit or Rash Guard"
//        case 75..<85:
//            return diveTime > 30 ? 3 : 4//"3-4mm Full Wetsuit": "3mm Full Wetsuit"
//        case 65..<75:
//            return diveTime > 40 ? 5 : 6//"5-7mm Full Wetsuit" : "5mm Full Wetsuit"
//        case 50..<65:
//            return diveTime > 30 ? 7 : 8//"Semi or full Dry Suit" : "7mm Wetsuit or Semi-Dry Suit"
//        default:
//            return 9//"Dry Suit (Below 50ºF)"
//        }
//    }
    
    //editing states
    @State private var isEditing = false //changes color of slider value when editing
    @State private var isDiveTimeEditing = false //allows you to edit dive time in other menus
    
    //Form fields
    
    //basic
    @State private var date = Date()
    @State private var location = ""
    
    //o
    @State private var p_depth = 0.0
    @State private var p_diveTime = 0.0 //Make this a time
    @State private var p_pctOxygen = 21.0 //Make this a pct
    
    //d
    enum Model: String, CaseIterable, Identifiable {
        case Naui, PADI
        var id: Self { self }
    }
    @State private var p_dcModel: Model = .Naui
    
    enum Group: String, CaseIterable, Identifiable {
        case A, B, C, D, E, F, G, H, I, J, K, L
        var id: Self { self }
    }
    @State private var p_sGroup: Group = .A
    @State private var p_eGroup: Group = .A
    
    
    //i
    @State private var bottomTime = 0
    
    //g
    @State private var p_startPressure = 3000.0
    
    //t
    @State private var rec = "none"
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
                ProgressView(value: Double(currentSection.rawValue), total: Double(DiveFormSection.allCases.count - 1)).foregroundColor(.blue)
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
                        
                    //Oxygen (with Bühlmann algorithm)
                    case .oxygen:
                        Slider(value: $p_depth, in: 0...130, step: 1//,
//                               onEditingChanged: { editing in
//                                    isEditing = editing
//                                }
                        ).onChange(of: p_depth) { _, _ in updateDiveCalculations() }
                        Text("Planned Depth: **\(Int(p_depth)) ft**")
                            .foregroundColor(isEditing ? .accentColor : .gray)
                        Slider(value: $p_diveTime, in: 0...120, step: 1//,
//                               onEditingChanged: { editing in
//                                    isEditing = editing
//                                }
                        ).onChange(of: p_diveTime) { _, _ in updateDiveCalculations() }

                        Text("Planned Dive Time: **\(Int(p_diveTime)) min**")
                            .foregroundColor(isEditing ? .accentColor : .gray)
                        Slider(value: $p_pctOxygen, in: 21...40, step: 1//,
//                               onEditingChanged: { editing in
//                                    isEditing = editing
//                                }
                        ).onChange(of: p_pctOxygen) { _, _ in updateDiveCalculations() }

                        Text("Percent Oxygen: **\(Int(p_pctOxygen)) %**")
                            .foregroundColor(isEditing ? .accentColor : .gray)
                        
                        if let results = diveResults{
                            Text("**\(safetyStatus)**")
                                .foregroundColor(results.isWithinLimits ? .green : .red)
                            
                            Text("No-Decompression Limit: \(Int(results.ndl)) minutes")
                                    Text("Maximum Operating Depth: \(Int(results.mod))ft")
                                    
                            if !results.decoStops.isEmpty {
                                Text("Required Decompression Stops:")
                                ForEach(results.decoStops, id: \.depth) { stop in
                                    Text("  • \(Int(stop.depth * 3.28084))ft for \(Int(stop.time)) minutes")
                                }
                                Text("Total Ascent Time: \(Int(results.totalAscentTime)) minutes")
                            }
                        }//changes calculations upon edit
                       
                    //Decompression
                    case .decompression:
                        //start group
                        Picker("Start Group", selection: $p_sGroup){
                            Text("A").tag(Group.A)
                            Text("B").tag(Group.B)
                            Text("C").tag(Group.C)
                            Text("D").tag(Group.D)
                            Text("E").tag(Group.E)
                            Text("F").tag(Group.F)
                            Text("G").tag(Group.G)
                            Text("H").tag(Group.H)
                            Text("I").tag(Group.I)
                            Text("J").tag(Group.J)
                            Text("K").tag(Group.K)
                            Text("L").tag(Group.L)
                        }
                        //pick model
                        Picker("Decompression Model", selection: $p_dcModel){
                            Text("NAUI").tag(Model.Naui)
                            Text("PADI").tag(Model.PADI)
                        }
                        //Show Dive Table
                        HStack{
                            Spacer()
                            if p_dcModel == Model.Naui {
                                Image("DiveTableNAUI")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                                    .foregroundStyle(.tint)
                                //                            .padding(EdgeInsets(top: 10, leading: 10, bottom:10, trailing: 5))
                            } else {
                                Image("DiveTablePADI")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 207)
                                    .foregroundStyle(.tint)
                                //                            .padding(EdgeInsets(top: 10, leading: 10, bottom:10, trailing: 5))
                            }
                            Spacer()
                        }
                        
                        
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
                        // Temperature Slider
                        VStack(alignment: .leading) {
                            Slider(value: $p_temp, in: 33...100, step: 1,
                                   onEditingChanged: { editing in
                                isEditing = editing
                            })
                            Text("Expected Temperature: **\(Int(p_temp))ºF**")
                                .foregroundColor(isEditing ? .accentColor : .black)
                        }
                        //Dive Time Slider
                        VStack(alignment: .leading) {
                            if isDiveTimeEditing {
                                Slider(value: $p_diveTime, in: 0...120, step: 1,
                                       onEditingChanged: { editing in
                                    isDiveTimeEditing = true
                                }
                                )
                                Text("Dive Time: \(Int(p_diveTime)) min")
                                    .foregroundColor(isDiveTimeEditing ? .black : .black)
                            }else{
                                Text("Dive Time: **\(Int(p_diveTime)) minutes** (Tap to Edit)")
                                    .foregroundColor(isDiveTimeEditing ? .accentColor : .black)
                                    .onTapGesture {
                                        isDiveTimeEditing.toggle()
                                    }
                            }
                        }
                        
                        //Recommendation
                        VStack(alignment: .leading){
                            Text("Recommendation:")
                            switch p_temp {
                            case 90...:
                                Text("**No wetsuit required**")
                                    .foregroundColor(.accentColor)
                                //should i put an image here?
                                HStack{
                                    Spacer()
                                    Image("none")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 95, height: 214)
                                        .foregroundStyle(.tint)
                                    Spacer()
                                }
                            case 80...:
                                Text("**\(p_diveTime > 30 ? "Shorty Wetsuit (2mm-3mm)" : "No wetsuit required")**")
                                    .foregroundColor(.orange)
                                if p_diveTime > 30{
                                    HStack{
                                        Spacer()
                                        Image("shorty")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 95, height: 214)
                                            .foregroundStyle(.tint)
                                        Spacer()
                                    }
                                }
                                else{
                                    HStack{
                                        Spacer()
                                        Image("none")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 95, height: 214)
                                            .foregroundStyle(.tint)
                                        Spacer()
                                    }
                                    }
                            case 70..<80:
                                Text("**\(p_diveTime > 30 ? "3-4mm Full Wetsuit": "3mm Full Wetsuit")**")
                                    .foregroundColor(.yellow)
                                HStack{
                                    Spacer()
                                    Image("3mm")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 95, height: 214)
                                        .foregroundStyle(.tint)
                                    Spacer()
                                }
                            case 65..<70:
                                Text("**\(p_diveTime > 30 ? "5-7mm Full Wetsuit" : "5mm Full Wetsuit")**")
                                    .foregroundColor(.teal)
                                HStack{
                                    Spacer()
                                    Image("5mm")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 95, height: 214)
                                        .foregroundStyle(.tint)
                                    Spacer()
                                }
                            case 50..<65:
                                Text("**\(p_diveTime > 30 ? "Semi or full Dry Suit" : "7mm Wetsuit or Semi-Dry Suit")**")
                                    .foregroundColor(.blue)
                                HStack{
                                    Spacer()
                                    Image("7mm")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 95, height: 214)
                                        .foregroundStyle(.tint)
                                    Spacer()
                                }
                            default:
                                Text("**Dry Suit**")
                                    .foregroundColor(.cyan)
                                HStack{
                                    Spacer()
                                    Image("dry")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 95, height: 214)
                                        .foregroundStyle(.tint)
                                    Spacer()
                                }
                            }
                        }
                        
                        Text("Plan For Expected Conditions:")
                        TextField("Notes about water conditions here...", text: $p_condNotes)
                            .textFieldStyle(.roundedBorder)
                        
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
                            let ref = Database.database().reference()
                            if let userID = Auth.auth().currentUser?.uid {
                                let newDive = Dive(
                                    date: date,
                                    location: location,
                                    p_depth: p_depth,
                                    p_diveTime: p_diveTime,
                                    p_pctOxygen: p_pctOxygen,
                                    p_dcModel: p_dcModel,
                                    p_sGroup: p_sGroup,
                                    p_eGroup: p_eGroup,
                                    bottomTime: bottomTime,
                                    p_startPressure: p_startPressure,
                                    p_temp: p_temp,
                                    p_condNotes: p_condNotes,
                                    notes: notes
                                )

                                let firebaseInfo = convertDiveToDict(dive: newDive)
                                
                                ref.child("users").child(userID).child("dives").child(newDive.id.uuidString).setValue(firebaseInfo) { error, _ in
                                    if let error = error {
                                        print("Error saving dive: \(error.localizedDescription)")
                                    } else {
                                        print("Dive saved successfully!")
                                        dives.append(newDive)
                                    }
                                }
                            }
                            dismiss()
                        }
                        .disabled(location.isEmpty)
                    }
                }
                .padding()
                .onAppear {
                    updateDiveCalculations()  // Calculate initial results when view appears
                }
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
        }
        .padding(.vertical, 4)
    }
}

// MyDivesView.swift
struct MyDivesView: View {
    @State private var showingNewDiveSheet = false
    @State private var isEditing = false
    @StateObject private var watchConnector = WatchConnector()
    @StateObject private var authViewModel = AuthViewModel()
    @State private var dives: [Dive] = []
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                if dives.isEmpty {
                    ContentUnavailableView(
                        "No Dives Yet",
                        systemImage: "water.waves.slash",
                        description: Text("Press '+' to plan your first dive!")
                    )
                } else {
                    List {
//                        fetchDives()
                        ForEach(dives) { dive in
                            DiveRow(dive: dive)
                        }
                        .onDelete(perform: deleteDives)
                    }
                }
                
                Button("Send to Watch"){
                    let locations = dives.map { $0.location }
                    let payload: [String: Any] = ["Dives": locations]
                    watchConnector.sendMessageToWatch(payload)
                    }
                
            }
            .navigationTitle("My Dives")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem() {
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
            .onAppear(){
                fetchDives()
            }
            
        }
    }
    func fetchDives() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(userID).child("dives")
        ref.observeSingleEvent(of: .value) { snapshot in
            var loadedDives: [Dive] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let diveData = childSnapshot.value as? [String: Any],
                   
                   
                   let dateString = diveData["date"] as? String,
                   let date = ISO8601DateFormatter().date(from: dateString),
//                   let id = diveData["id"] as? String,
                   let location = diveData["location"] as? String,
                   let p_depth = diveData["p_depth"] as? Double,
                   let p_diveTime = diveData["p_diveTime"] as? Double,
                   let p_pctOxygen = diveData["p_pctOxygen"] as? Double,
                   let bottomTime = diveData["bottomTime"] as? Int,
                   let p_startPressure = diveData["p_startPressure"] as? Double,
                   let p_temp = diveData["p_temp"] as? Double,
                   let p_condNotes = diveData["p_condNotes"] as? String,
                   let notes = diveData["notes"] as? String {
                    
                    let p_dcModel = (diveData["p_dcModel"] as? String) == "Naui" ? NewDiveView.Model.Naui : NewDiveView.Model.PADI
                    let p_sGroup = NewDiveView.Group(rawValue: diveData["p_sGroup"] as? String ?? "A") ?? .A
                    let p_eGroup = NewDiveView.Group(rawValue: diveData["p_eGroup"] as? String ?? "A") ?? .A
                    print("Fetched dive data:", diveData)
                    let dive = Dive(
//                        id: UUID(uuidString: childSnapshot.key) ?? UUID(),
                        date: date,
                        location: location,
                        p_depth: p_depth,
                        p_diveTime: p_diveTime,
                        p_pctOxygen: p_pctOxygen,
                        p_dcModel: p_dcModel,
                        p_sGroup: p_sGroup,
                        p_eGroup: p_eGroup,
                        bottomTime: bottomTime,
                        p_startPressure: p_startPressure,
                        p_temp: p_temp,
                        p_condNotes: p_condNotes,
                        notes: notes
                    )
                    loadedDives.append(dive)
                }
            }
            
            DispatchQueue.main.async {
                self.dives = loadedDives
            }
        }
    }
    
  
    private func deleteDives(at offsets: IndexSet) {
        let divesToDelete = offsets.map { dives[$0] }

        guard let userID = Auth.auth().currentUser?.uid else { return }

        let ref = Database.database().reference()
        
        for dive in divesToDelete {
            print("Fetched dive data:", dive)
            print("Deleting dive with ID: \(dive.id)")
            ref.child("users").child(userID).child("dives").child(dive.id.uuidString).removeValue { error, _ in
                if let error = error {
                    print("Error deleting dive from Firebase: \(error.localizedDescription)")
                } else {
                    print("Dive successfully deleted from Firebase")
                }
            }
        }
        
        dives.remove(atOffsets: offsets)
        
    }
    
}

#Preview {
    ContentView()
}
