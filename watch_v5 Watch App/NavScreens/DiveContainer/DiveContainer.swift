//  DiveContainer.swift
//  watch_v5
//      This is a container that is displayed while diving. it holds multiple screens that can be scrolled between
//  Created by Jack Skupien on 3/31/25.

import SwiftUI

struct DiveContainerView: View {
    @FocusState private var focusedIndex: Int?
    @EnvironmentObject var manager: HealthManager
    var body: some View{
        TabView{
            //Page 1: Metrics
            DiveMetricsView().environmentObject(manager).tag(0)
            
            //Page 2: Modular Compass
            ModularCompassView().tag(1)
        }
        .tabViewStyle(.carousel)//swap pages with digital crown
    }
}

#Preview {
    DiveContainerView().environmentObject(HealthManager())
}
