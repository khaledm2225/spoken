import SwiftUI

/// Onboarding screen four: how many words a day.
///
/// This is the last screen, so it commits the choices. It opens on five words
/// already chosen, which is why its button is never disabled.
struct DailyGoalScreen: View {
    @Binding var selection: DailyGoal

    var body: some View {
        VStack(alignment: .leading, spacing: Space.l) {
            ScreenHeading(
                title: "How many words a day?",
                subtitle: "Small and steady wins"
            )
            .reveal(index: 0)

            VStack(spacing: Space.s) {
                ForEach(Array(DailyGoal.allCases.enumerated()), id: \.element) { index, goal in
                    GoalCard(
                        goal: goal,
                        isSelected: selection == goal,
                        action: { selection = goal }
                    )
                    .reveal(index: index + 1)
                }
            }
        }
        .sensoryFeedback(.selection, trigger: selection)
    }
}

#Preview {
    @Previewable @State var goal: DailyGoal = .five
    ZStack {
        AmbientBackground()
        DailyGoalScreen(selection: $goal)
            .padding(Space.xl)
    }
}
