import SwiftUI

struct GuidedMeditationView: View {
    @State private var isActive: Bool = false
    @State private var meditationDuration: Int = 10
    
    var body: some View {
        VStack {
            Text("Guided Meditation")
                .font(.largeTitle)
                .padding()
            
            Text("Duration: \(meditationDuration) minutes")
                .font(.title2)
                .padding()
            
            Button(action: {
                startMeditation()
            }) {
                Text("Start Meditation")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
        }
    }
    
    func startMeditation() {
        isActive = true
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(meditationDuration) * 60) {
            isActive = false
        }
    }
}

struct GuidedMeditationView_Previews: PreviewProvider {
    static var previews: some View {
        GuidedMeditationView()
    }
}
