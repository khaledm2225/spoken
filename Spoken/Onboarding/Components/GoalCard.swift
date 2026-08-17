import SwiftUI

/// One daily goal on screen four: how many words, and roughly how long that
/// takes.
///
/// The badge keeps its place even when the card is not chosen, so the estimates
/// line up down the column instead of shifting when a pick moves.
struct GoalCard: View {
    let goal: DailyGoal
    let isSelected: Bool
    let action: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button(action: action) {
            ViewThatFits(in: .horizontal) {
                HStack(spacing: Space.m) {
                    title.frame(maxWidth: .infinity, alignment: .leading)
                    estimate
                    badge
                }

                // At large type sizes the row stops fitting, so it stacks.
                VStack(alignment: .leading, spacing: Space.xs) {
                    HStack(spacing: Space.m) {
                        title.frame(maxWidth: .infinity, alignment: .leading)
                        badge
                    }
                    estimate
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Space.m)
            .padding(.vertical, Space.l)
            .surfaceCard(cornerRadius: Radius.option, isSelected: isSelected)
        }
        .buttonStyle(.pressable)
        .animation(Motion.pop(reduceMotion: reduceMotion), value: isSelected)
        .accessibilityLabel("\(goal.title), \(goal.estimate)")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }

    private var title: some View {
        Text(goal.title)
            .uiText(20, .semibold)
            .foregroundStyle(Palette.ink)
    }

    private var estimate: some View {
        Text(goal.estimate)
            .uiText(15)
            .foregroundStyle(Palette.muted)
    }

    /// Always laid out, only visible when chosen.
    private var badge: some View {
        SelectionBadge()
            .opacity(isSelected ? 1 : 0)
    }
}

#Preview {
    ZStack {
        AmbientBackground()
        VStack(spacing: Space.s) {
            ForEach(DailyGoal.allCases) { goal in
                GoalCard(goal: goal, isSelected: goal == .five, action: {})
            }
        }
        .padding(Space.xl)
    }
}
