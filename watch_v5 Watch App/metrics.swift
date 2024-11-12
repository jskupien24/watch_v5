import SwiftUI

struct EssentialDiveMetricsView: View {
    @State private var depth = "72 ft"
    @State private var waterTemp = "82°F"
    @State private var heartRate = "76 BPM"
    @State private var diveTime = "00:22:36"

    var body: some View {
        VStack {
            Text("Dive Computer")
                .font(.caption)
                .padding(.top, 4)

            HStack {
                VStack {
                    Text("Depth")
                        .font(.caption2)
                    Text(depth)
                        .font(.title2)
                        .bold()
                }
                VStack {
                    Text("Temp")
                        .font(.caption2)
                    Text(waterTemp)
                        .font(.title2)
                        .bold()
                }
            }
            .padding(.vertical, 4)

            Text("Heart Rate: \(heartRate)")
                .font(.body)
                .padding(.vertical, 2)

            Text("Dive Time: \(diveTime)")
                .font(.body)
                .padding(.bottom, 4)
        }
        .padding()
    }
}
