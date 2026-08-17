import SwiftUI

/// The small sample words shown on a level card.
///
/// They are a preview of the difficulty, not controls, so the row reads as one
/// piece to VoiceOver instead of three stray words. `ViewThatFits` drops the row
/// into a column when the words stop fitting side by side at large type sizes,
/// so nothing is squeezed or cut.
struct WordTagRow: View {
    let words: [String]

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: Space.xs) {
                tags
            }
            VStack(alignment: .leading, spacing: Space.xs) {
                tags
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("For example: \(words.joined(separator: ", "))")
    }

    private var tags: some View {
        ForEach(words, id: \.self) { word in
            Text(word)
                .uiText(15, .medium)
                .foregroundStyle(Palette.ink)
                .padding(.horizontal, Space.s)
                .padding(.vertical, Space.xs)
                .surfaceCard(cornerRadius: Radius.tag)
        }
    }
}

#Preview {
    ZStack {
        AmbientBackground()
        WordTagRow(words: Level.newLearner.sampleWords)
            .padding(Space.xl)
    }
}
