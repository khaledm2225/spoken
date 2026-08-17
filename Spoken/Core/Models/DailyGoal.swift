import Foundation

/// How many words a learner wants each day, picked on the fourth onboarding
/// screen. The raw value is the word count, which the home progress row counts
/// towards.
enum DailyGoal: Int, Codable, CaseIterable, Identifiable, Hashable {
    case five = 5
    case ten = 10
    case twenty = 20

    /// What a learner starts on if they never change it.
    static let `default`: DailyGoal = .five

    var id: Int { rawValue }

    var wordCount: Int { rawValue }

    var title: String { "\(rawValue) words" }

    var estimate: String {
        switch self {
        case .five: "about 2 minutes"
        case .ten: "about 5 minutes"
        case .twenty: "about 10 minutes"
        }
    }
}
