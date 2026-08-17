import Foundation

/// How much English the learner already knows, picked on the second onboarding
/// screen. The choice decides which words the home screen deals out.
enum Level: String, Codable, CaseIterable, Identifiable, Hashable {
    case newLearner
    case gettingBetter
    case confident

    var id: String { rawValue }

    var title: String {
        switch self {
        case .newLearner: "New learner"
        case .gettingBetter: "Getting better"
        case .confident: "Confident"
        }
    }

    var subtitle: String {
        switch self {
        case .newLearner: "I know a few words"
        case .gettingBetter: "I can make sentences"
        case .confident: "I want harder words"
        }
    }

    /// The three words shown on the level card, so a learner can feel the
    /// difficulty before choosing.
    var sampleWords: [String] {
        switch self {
        case .newLearner: ["happy", "light", "begin"]
        case .gettingBetter: ["honest", "brave", "wonder"]
        case .confident: ["vivid", "subtle", "keen"]
        }
    }
}
