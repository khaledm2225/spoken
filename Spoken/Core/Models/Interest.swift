import Foundation

/// The eight topics a learner can pick on the third onboarding screen.
/// Each word carries one example sentence per interest, so the examples a
/// learner sees always match what they chose.
enum Interest: String, Codable, CaseIterable, Identifiable, Hashable {
    case football
    case movies
    case money
    case travel
    case food
    case music
    case games
    case dailyLife

    var id: String { rawValue }

    var title: String {
        switch self {
        case .football: "Football"
        case .movies: "Movies"
        case .money: "Money"
        case .travel: "Travel"
        case .food: "Food"
        case .music: "Music"
        case .games: "Games"
        case .dailyLife: "Daily life"
        }
    }
}

/// Lets `[Interest: String]` encode as a plain JSON object keyed by the raw
/// values, instead of the array of alternating keys and values Swift would
/// otherwise produce.
extension Interest: CodingKeyRepresentable {}
