import SwiftUI

/// Onboarding screen two: how much English the learner already knows.
///
/// One choice only. The chosen level decides which words the home screen deals
/// out, so Continue stays off until something is picked. The heading and the
/// three cards arrive one beat apart.
struct LevelScreen: View {
    @Binding var selection: Level?

    var body: some View {
        VStack(alignment: .leading, spacing: Space.l) {
            ScreenHeading(
                title: "How much English do you know?",
                subtitle: "Pick one to set your words"
            )
            .reveal(index: 0)

            VStack(spacing: Space.s) {
                ForEach(Array(Level.allCases.enumerated()), id: \.element) { index, level in
                    SelectableCard(
                        title: level.title,
                        subtitle: level.subtitle,
                        isSelected: selection == level,
                        action: { selection = level }
                    ) {
                        WordTagRow(words: level.sampleWords)
                    }
                    .reveal(index: index + 1)
                }
            }
        }
        .sensoryFeedback(.selection, trigger: selection)
    }
}

#Preview {
    @Previewable @State var level: Level? = .newLearner
    ZStack {
        AmbientBackground()
        LevelScreen(selection: $level)
            .padding(Space.xl)
    }
}
