import SwiftUI

struct DurationPickerView: View {
    @Binding var selectedDuration: Int
    var startAction: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("Select Duration")
                .font(.title3)
                .fontWeight(.medium)
            
            Picker("Duration", selection: $selectedDuration) {
                Text("2 min").tag(120)
                Text("4 min").tag(240)
                Text("5 min").tag(300)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 40)
            
            Button(action: startAction) {
                Text("Start")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
    }
}
