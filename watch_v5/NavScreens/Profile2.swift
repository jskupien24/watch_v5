//
//  Profile2.swift
//  watch_v5
//
//  Created by Faith Chernowski on 3/4/25.
//
import SwiftUI
import Charts

struct ProfileView2: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showingSettings = false
    
    // Example Dive Data
    let diveLog: [DiveEntry] = [
        DiveEntry(date: "Feb 1", depth: 18),
        DiveEntry(date: "Feb 5", depth: 25),
        DiveEntry(date: "Feb 10", depth: 12),
        DiveEntry(date: "Feb 18", depth: 30),
        DiveEntry(date: "Feb 24", depth: 22),
        DiveEntry(date: "Mar 2", depth: 35)
    ]
    
    var body: some View {
        Group{
            if authViewModel.isAuthenticated{
                NavigationView {
                    ScrollView {
                        VStack {
                            // Profile Header with Gradient
                            ZStack {
                                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                                    .edgesIgnoringSafeArea(.top)
                                    .frame(height: 220)
                                
                                VStack {
                                    Image("ProfilePicture")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                        .shadow(radius: 5)
                                    
                                    Text("\(authViewModel.userData["name"] ?? "John Doe")")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .bold()
                                    
                                    Text("\(authViewModel.userData["bio"] ?? "Diver | Explorer | Ocean Enthusiast")")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding(.top, 40)
                            }
                            
                            // Diving Stats Section
                            VStack(spacing: 12) {
                                HStack(spacing: 20) {
                                    DiveStatCard(title: "Total Dives", value: "15")
                                    DiveStatCard(title: "Bottom Time", value: "10h 30m")
                                    DiveStatCard(title: "Max Depth", value: "35m")
                                }
                                .padding()
                            }
                            
                            // Dive Log Graph - Wider
                            VStack {
                                Text("Dive Log (Depth Over Time)")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .padding(.top)
                                
                                Chart(diveLog) { dive in
                                    LineMark(
                                        x: .value("Date", dive.date),
                                        y: .value("Depth", dive.depth)
                                    )
                                    .foregroundStyle(Color.blue)
                                }
                                .frame(height: 200) // Increased height
                                .padding()
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 3)
                            .padding(.horizontal)
                            // Link to Activities Page
                            NavigationLink(destination: ActivitiesPage()) {
                                Text("View All Dive Activities")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }

                            
                            // Certifications Section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Certifications")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.blue)
                                    .padding(.top)
                                
                                VStack(alignment: .leading) {
                                    CertificationBadge(title: "Advanced Open Water Diver")
                                    CertificationBadge(title: "Rescue Diver")
                                    CertificationBadge(title: "Enriched Air (Nitrox) Diver")
                                }
                            }
                            .padding()
                            
                            Spacer()
                        }
                    }
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showingSettings = true
                                print("what")
                                
                            }) {
                                Image(systemName: "gear")
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            }
                        }
                        
                    }
                    .sheet(isPresented: $showingSettings) {
                        SettingsView()
                    }
                }
            }else{
                LogIn()
            }
        }
    }
}


// Custom Dive Stat Card Component
struct DiveStatCard: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .bold()
                .foregroundColor(.blue)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 110, height: 80)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// Custom Certification Badge Component
struct CertificationBadge: View {
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(.blue)
            Text(title)
                .font(.body)
                .foregroundColor(.black)
        }
        .padding(.vertical, 5)
    }
}

// Dive Log Entry Model
struct DiveEntry: Identifiable {
    let id = UUID()
    let date: String
    let depth: Int
}

// SwiftUI Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView2()
    }
}
