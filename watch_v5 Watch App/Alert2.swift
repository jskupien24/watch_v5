import SwiftUI

struct OffCourseAlertView: View {
    @State private var message = "Off Course Warning"

    var body: some View {
        VStack(spacing: 10) {
            Text(message)
                .font(.headline)
                .foregroundColor(.red)
            Text("Return to course or ascend")
            Button(action: {
                print("Acknowledged")
            }) {
                Text("Acknowledge")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
        }
        .padding()
        .navigationTitle("Alert")
    }
}

struct OffCourseAlertView_Previews: PreviewProvider {
    static var previews: some View {
        OffCourseAlertView()
    }
}
