import Foundation

struct BreathingExercise: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var animationSequence: [CGFloat]
    var phaseDurations: [UInt64]
    var instructions: [String]
    
    static let allExercises: [BreathingExercise] = [
        BreathingExercise(
            name: "4-7-8 Breathing",
            description: "Calming technique for stress reduction",
            animationSequence: [1.0, 1.3, 1.5],
            phaseDurations: [4, 7, 8],
            instructions: ["Inhale for 4 seconds", "Hold for 7 seconds", "Exhale for 8 seconds"]
        ),
        BreathingExercise(
            name: "Box Breathing",
            description: "Military technique for focus and calm",
            animationSequence: [1.0, 1.2, 1.0, 1.2],
            phaseDurations: [4, 4, 4, 4],
            instructions: ["Inhale for 4 seconds", "Hold for 4 seconds", "Exhale for 4 seconds", "Hold for 4 seconds"]
        ),
        BreathingExercise(
            name: "4-4-4 Breathing",
            description: "Simple equal ratio breathing",
            animationSequence: [1.0, 1.2, 1.0],
            phaseDurations: [4, 4, 4],
            instructions: ["Inhale for 4 seconds", "Hold for 4 seconds", "Exhale for 4 seconds"]
        ),
        BreathingExercise(
            name: "Deep Belly Breathing",
            description: "Diaphragmatic breathing for relaxation",
            animationSequence: [1.0, 1.5],
            phaseDurations: [5, 7],
            instructions: ["Slow inhale for 5 seconds", "Long exhale for 7 seconds"]
        )
    ]
}
