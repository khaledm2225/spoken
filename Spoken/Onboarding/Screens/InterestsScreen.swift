import SwiftUI

/// Onboarding screen three: the topics the learner cares about.
///
/// Pick as many as you like, at least one. The picks decide which example
/// sentence each word card shows on the home screen.
struct InterestsScreen: View {
    @Binding var selection: Set<Interest>

    var body: some View {
        VStack(alignment: .leading, spacing: Space.l) {
            ScreenHeading(
                title: "What do you like?",
                subtitle: "Your examples will match your picks"
            )
            .reveal(index: 0)

            FlowLayout {
                ForEach(Array(Interest.allCases.enumerated()), id: \.element) { index, interest in
                    InterestChip(
                        interest: interest,
                        isSelected: selection.contains(interest),
                        action: { toggle(interest) }
                    )
                    .reveal(index: index + 1)
                }
            }
        }
        .sensoryFeedback(.selection, trigger: selection)
    }

    private func toggle(_ interest: Interest) {
        if selection.contains(interest) {
            selection.remove(interest)
        } else {
            selection.insert(interest)
        }
    }
}

#Preview {
    @Previewable @State var picks: Set<Interest> = [.football, .movies]
    ZStack {
        AmbientBackground()
        InterestsScreen(selection: $picks)
            .padding(Space.xl)
    }
}
