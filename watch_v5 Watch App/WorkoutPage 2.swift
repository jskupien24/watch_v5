//
//  WorkoutPage 2.swift
//  watch_v5
//
//  Created by Jack Skupien on 2/24/25.
//

import SwiftUI

struct WorkoutPage2: View {
    @EnvironmentObject var manager: HealthManager
    var body: some View {
//        .EnvironmentObject(manager)
        ZStack {
            Text("Heart Rate")
                .bold()
                .font(.system(size: 28))
                .position(x: 70, y: 0)
            Text("123")
                .foregroundColor(Color.red)
                .bold()
                .font(.system(size: 28))
                .position(x: 170, y: 0)
            Text("Temp")
                .bold()
                .font(.system(size: 28))
                .position(x: 40, y: 50)
            Text("50 F")
                .foregroundColor(Color.blue)
                .bold()
                .font(.system(size: 28))
                .position(x: 130, y: 50)
            Text("Elapsed Time")
                .bold()
                .font(.system(size: 28))
                .position(x: 80, y: 100)
            Text("00:35:12")
                .foregroundColor(Color.yellow)
                .bold()
                .font(.system(size: 28))
                .position(x: 60, y: 140)

        }//end zstack
    }//end view
}//end struct

#Preview {
    WorkoutPage2()
}//end preview
