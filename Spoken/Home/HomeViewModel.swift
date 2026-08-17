import Foundation

/// Drives the home screen: which words are left, which one is on top, and how
/// many have been dealt with today.
///
/// It does not navigate and it does not know about gestures. The view tells it
/// a card was swiped; it moves the deck along.
@Observable
final class HomeViewModel {
    /// What a swipe meant.
    enum Swipe {
        case skip
        case knowIt
    }

    private(set) var words: [Word] = []
    private(set) var index = 0
    /// Cards dealt with today. Both a skip and an "I know it" move the day on.
    private(set) var done = 0
    private(set) var loadFailed = false

    let goal: DailyGoal
    private let interests: [Interest]

    /// Every swipe so far, newest last. Step 9's undo reads from here.
    private(set) var history: [Swipe] = []

    init(loader: WordsLoader, settings: SettingsStore) {
        goal = settings.dailyGoal ?? .default
        let picked = settings.interests
        interests = picked.isEmpty
            ? Interest.allCases
            : Interest.allCases.filter(picked.contains)

        do {
            let all = try loader.loadWords()
            let level = settings.level
            let matching = all.filter { level == nil || $0.level == level }
            // Today's deck is exactly the daily goal. Without this the learner
            // can pass their own target and the progress row reads "6 of 5".
            words = Array((matching.isEmpty ? all : matching).prefix(goal.wordCount))
        } catch {
            loadFailed = true
        }
    }

    /// The cards still to be dealt, nearest first.
    var remaining: ArraySlice<Word> {
        guard index < words.count else { return [] }
        return words[index...]
    }

    var isFinished: Bool { index >= words.count }

    /// The example sentence for a word, and the interest it came from.
    ///
    /// The interest is chosen from the learner's picks by the word's position,
    /// so a card always shows the same sentence rather than changing on redraw,
    /// and a learner with several interests sees them spread across the deck.
    func example(for word: Word) -> (sentence: String, interest: Interest)? {
        guard !interests.isEmpty,
              let position = words.firstIndex(of: word) else { return nil }
        let interest = interests[position % interests.count]
        guard let sentence = word.example(for: interest) else { return nil }
        return (sentence, interest)
    }

    /// Moves past the top card.
    func commit(_ swipe: Swipe) {
        guard !isFinished else { return }
        index += 1
        done += 1
        history.append(swipe)
    }
}
