import SwiftUI

/// One short pill per onboarding screen, with the current one filled.
struct ProgressPills: View {
    let current: OnboardingStep

    /// Fixed decorative geometry: the pills carry no text.
    private let pillWidth: CGFloat = 28
    private let pillHeight: CGFloat = 6

    var body: some View {
        HStack(spacing: Space.xs) {
            ForEach(OnboardingStep.allCases) { step in
                Capsule()
                    .fill(step == current ? Palette.accent : Palette.hairline)
                    .frame(width: pillWidth, height: pillHeight)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Step \(current.index + 1) of \(OnboardingStep.allCases.count)")
    }
}

#Preview {
    ZStack {
        AmbientBackground()
        ProgressPills(current: .welcome)
    }
}
