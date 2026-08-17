import SwiftUI

/// One short pill per onboarding screen, with the current one filled.
///
/// The filled pill is a single accent capsule that slides from step to step
/// rather than four pills toggling, so the learner sees progress move. Under
/// Reduce Motion the fill simply changes.
struct ProgressPills: View {
    let current: OnboardingStep

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var pills

    /// Fixed decorative geometry: the pills carry no text.
    private let pillWidth: CGFloat = 28
    private let pillHeight: CGFloat = 6

    var body: some View {
        HStack(spacing: Space.xs) {
            ForEach(OnboardingStep.allCases) { step in
                Capsule()
                    .fill(reduceMotion && step == current ? Palette.accent : Palette.hairline)
                    .frame(width: pillWidth, height: pillHeight)
                    .matchedGeometryEffect(id: step, in: pills, isSource: true)
            }
        }
        .overlay {
            if !reduceMotion {
                Capsule()
                    .fill(Palette.accent)
                    .matchedGeometryEffect(id: current, in: pills, isSource: false)
            }
        }
        .animation(Motion.push(reduceMotion: reduceMotion), value: current)
        .accessibilityElement()
        .accessibilityLabel("Step \(current.index + 1) of \(OnboardingStep.allCases.count)")
    }
}

#Preview {
    ZStack {
        AmbientBackground()
        ProgressPills(current: .level)
    }
}
