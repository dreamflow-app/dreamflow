import Foundation
import SwiftUI

class UserStatsViewModel: ObservableObject {
    @Published var exercisesCompleted: Int = 0
    private var username: String = ""
    
    init(username: String = "") {
        self.username = username
        loadStats()
    }
    
    func loadStats() {
        let key = "\(username)_stats"
        if let data = UserDefaults.standard.data(forKey: key),
           let stats = try? JSONDecoder().decode(UserStatsData.self, from: data) {
            exercisesCompleted = stats.exercisesCompleted
        }
    }
    
    func saveStats() {
        let key = "\(username)_stats"
        let stats = UserStatsData(exercisesCompleted: exercisesCompleted)
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func resetStats() {
        exercisesCompleted = 0
        saveStats()
    }
    
    func updateStatsForExercise() {
        exercisesCompleted += 1
        saveStats()
    }
}

struct UserStatsData: Codable {
    var exercisesCompleted: Int
    
    enum CodingKeys: String, CodingKey {
        case exercisesCompleted
    }
}
