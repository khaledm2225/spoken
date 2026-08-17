import SwiftUI

/// The face of one vocabulary card: the word, how to say it, what it means, and
/// a sentence drawn from something the learner said they like.
struct WordCard: View {
    let word: Word
    let example: (sentence: String, interest: Interest)?

    var body: some View {
        // The card holds its shape in the deck, so at accessibility type sizes
        // the words inside scroll rather than being cut short. Nothing on a
        // vocabulary card is optional enough to truncate.
        //
        // The reader measures the card's own bounds, which is what lets short
        // content sit centred and long content grow past the bottom and scroll.
        GeometryReader { proxy in
            ScrollView {
                content
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .scrollBounceBehavior(.basedOnSize)
            .scrollIndicators(.never)
        }
        .cardSurface()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(voiceOverLabel)
    }

    private var content: some View {
        VStack(spacing: Space.m) {
            Spacer(minLength: 0)

            Text(word.text)
                .wordText(56, .regular)
                .foregroundStyle(Palette.ink)
                // A single word has nowhere to wrap, so at the largest type
                // sizes it is allowed to shrink a fifth to stay inside the card.
                // It is still by far the biggest thing on screen.
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            HStack(spacing: Space.xs) {
                Text(word.pronunciation.uppercased())
                    .tracking(2)
                Text("·")
                Text(word.partOfSpeech)
            }
            .uiText(13, .medium)
            .foregroundStyle(Palette.muted)

            Text(word.meaning)
                .uiText(17)
                .foregroundStyle(Palette.ink)
                .multilineTextAlignment(.center)

            if let example {
                Text(example.sentence)
                    .uiText(17)
                    .italic()
                    .foregroundStyle(Palette.ink)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(Space.m)
                    .background(Palette.accent.opacity(0.08), in: Radius.shape(Radius.option))

                Text("from your pick: \(example.interest.title)")
                    .uiText(13)
                    .foregroundStyle(Palette.muted)
                    .multilineTextAlignment(.center)
            }

            Spacer(minLength: 0)
        }
        .padding(Space.l)
    }

    /// One card, one VoiceOver element, read in the order a learner would read it.
    private var voiceOverLabel: String {
        var sentence = "\(word.text). \(word.partOfSpeech). \(word.meaning)."
        if let example { sentence += " Example: \(example.sentence)" }
        return sentence
    }
}

extension View {
    /// The shape and fill every card in the deck shares.
    ///
    /// The fill is solid, not translucent. The cards are stacked, so any
    /// transparency lets the word waiting underneath show through the one on
    /// top, which reads as a printing error.
    func cardSurface() -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Palette.surface, in: Radius.shape(Radius.card))
            .overlay(Radius.shape(Radius.card).strokeBorder(Palette.surface, lineWidth: 1))
    }
}

#Preview {
    ZStack {
        AmbientBackground()
        WordCard(
            word: Word(
                id: "brave", text: "brave", pronunciation: "BRAYV",
                partOfSpeech: "adjective", meaning: "not afraid of hard things",
                level: .gettingBetter, examples: [.football: "The brave player stayed calm."]
            ),
            example: ("The brave player stayed calm.", .football)
        )
        .padding(Space.xl)
    }
}
