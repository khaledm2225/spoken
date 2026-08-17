import SwiftUI

/// How far through today's goal the learner is: a label, a count and a thin bar.
struct ProgressRow: View {
    let done: Int
    let goal: DailyGoal

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// The bar carries no text, so a fixed height is fine here.
    private let barHeight: CGFloat = 5

    private var fraction: Double {
        guard goal.wordCount > 0 else { return 0 }
        return min(1, Double(done) / Double(goal.wordCount))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Space.s) {
            ViewThatFits(in: .horizontal) {
                HStack(spacing: Space.m) {
                    todayLabel.frame(maxWidth: .infinity, alignment: .leading)
                    countLabel
                }
                VStack(alignment: .leading, spacing: Space.xs) {
                    todayLabel
                    countLabel
                }
            }

            bar
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Today")
        .accessibilityValue("\(done) of \(goal.wordCount) words")
    }

    private var todayLabel: some View {
        Text("Today")
            .uiText(20, .semibold)
            .foregroundStyle(Palette.ink)
    }

    private var countLabel: some View {
        Text("\(done) of \(goal.wordCount) words")
            .uiText(15)
            .foregroundStyle(Palette.muted)
    }

    private var bar: some View {
        Capsule()
            .fill(Palette.ink.opacity(0.10))
            .frame(height: barHeight)
            .overlay(alignment: .leading) {
                // The filled part is a share of whatever width the bar was
                // given, so it holds on any screen without measuring one.
                GeometryFreeFill(fraction: fraction)
            }
            .animation(Motion.push(reduceMotion: reduceMotion), value: fraction)
    }
}

/// Fills a fraction of the space it is handed, using a spacer of the remaining
/// share rather than reading the screen's width.
private struct GeometryFreeFill: View {
    let fraction: Double

    var body: some View {
        HStack(spacing: 0) {
            Capsule()
                .fill(Palette.accent)
                .containerRelativeFrame(.horizontal) { width, _ in
                    width * max(0.001, fraction)
                }
            Color.clear
        }
    }
}

#Preview {
    ZStack {
        AmbientBackground()
        VStack(spacing: Space.xl) {
            ProgressRow(done: 0, goal: .five)
            ProgressRow(done: 2, goal: .five)
            ProgressRow(done: 5, goal: .five)
        }
        .padding(Space.xl)
    }
}
