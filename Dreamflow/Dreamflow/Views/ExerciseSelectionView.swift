import SwiftUI

struct ExerciseSelectionView: View {
    let exercises = BreathingExercise.allExercises
    @EnvironmentObject var userStats: UserStatsViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Choose a Breathing Exercise")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding(.top)
                    
                    ForEach(exercises) { exercise in
                        NavigationLink(destination: ExerciseView(exercise: exercise).environmentObject(userStats)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(exercise.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(exercise.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("Exercises")
        }
    }
}
