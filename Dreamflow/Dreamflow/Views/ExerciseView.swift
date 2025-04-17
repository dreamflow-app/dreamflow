import SwiftUI

struct ExerciseView: View {
    var exercise: BreathingExercise
    @State private var animationPhase: Int = 0
    @State private var isExerciseComplete = false
    @State private var selectedDuration: Int = 240
    @State private var showDurationPicker: Bool = true
    @State private var timeRemaining: Int = 0
    @State private var exerciseTimer: Timer?
    @State private var lungScale: CGFloat = 1.0
    @State private var lungOpacity: Double = 1.0
    @State private var instructionText = "Prepare to begin"
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            VStack(spacing: 30) {
                if !showDurationPicker {
                    Text(formatTime(seconds: timeRemaining))
                        .font(.system(size: 36, design: .monospaced))
                        .padding(.top)
                    
                    Text(exercise.name)
                        .font(.title2)
                        .fontWeight(.medium)
                }
                
                if !showDurationPicker {
                    ZStack {
                        Image(systemName: "lungs.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 160)
                            .foregroundColor(.blue)
                            .scaleEffect(lungScale)
                            .opacity(lungOpacity)
                        
                        if !isExerciseComplete {
                            BreathingArrowsView(phase: animationPhase % exercise.phaseDurations.count)
                        }
                    }
                    
                    VStack {
                        Text(instructionText)
                            .font(.title3)
                            .fontWeight(.medium)
                        
                        if exercise.instructions.indices.contains(animationPhase % exercise.instructions.count) {
                            Text(exercise.instructions[animationPhase % exercise.instructions.count])
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            
            if showDurationPicker {
                DurationPickerView(selectedDuration: $selectedDuration) {
                    startExercise()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            exerciseTimer?.invalidate()
        }
    }
    
    private func startExercise() {
        withAnimation {
            showDurationPicker = false
            timeRemaining = selectedDuration
            startBreathingCycle()
            startExerciseTimer()
        }
    }
    
    private func startBreathingCycle() {
        Task {
            while timeRemaining > 0 {
                for (index, _) in exercise.phaseDurations.enumerated() {
                    guard timeRemaining > 0 else { break }
                    animationPhase = index
                    await animatePhase(phaseIndex: index, duration: Double(exercise.phaseDurations[index]))
                }
            }
            completeExercise()
        }
    }
    
    private func animatePhase(phaseIndex: Int, duration: Double) async {
        withAnimation {
            if exercise.instructions.indices.contains(phaseIndex % exercise.instructions.count) {
                instructionText = exercise.instructions[phaseIndex % exercise.instructions.count]
            }
        }
        
        await withCheckedContinuation { continuation in
            withAnimation(.easeInOut(duration: duration)) {
                // Use the same animation sequence for all exercises
                switch phaseIndex % 3 {
                case 0: // Inhale
                    lungScale = 1.5
                    lungOpacity = 1.0
                case 1: // Hold
                    lungScale = 1.3
                    lungOpacity = 0.8
                default: // Exhale
                    lungScale = 1.0
                    lungOpacity = 0.5
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                continuation.resume()
            }
        }
    }
    
    private func startExerciseTimer() {
        exerciseTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                exerciseTimer?.invalidate()
            }
        }
    }
    
    private func completeExercise() {
        withAnimation {
            isExerciseComplete = true
            instructionText = "Session Complete"
        }
    }
    
    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

struct BreathingArrowsView: View {
    let phase: Int
    
    var body: some View {
        Group {
            if phase % 3 == 0 {
                Image(systemName: "arrow.down")
                    .font(.title)
                    .foregroundColor(.blue)
            } else if phase % 3 == 1 {
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundColor(.gray)
            } else {
                Image(systemName: "arrow.up")
                    .font(.title)
                    .foregroundColor(.blue)
            }
        }
    }
}
