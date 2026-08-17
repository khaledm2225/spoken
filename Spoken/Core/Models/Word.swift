import Foundation

/// One vocabulary word and everything the card shows for it.
///
/// `examples` holds one sentence per interest, so the home screen can pick the
/// sentence that matches what the learner chose during onboarding.
struct Word: Codable, Identifiable, Hashable {
    let id: String
    let text: String
    /// A simple respelling, such as `BRAYV`, not a phonetic alphabet.
    let pronunciation: String
    let partOfSpeech: String
    let meaning: String
    let level: Level
    let examples: [Interest: String]

    /// The example sentence for one of the learner's interests.
    /// Falls back to any sentence the word has, so a card is never blank.
    func example(for interest: Interest) -> String? {
        examples[interest] ?? examples.values.sorted().first
    }
}
