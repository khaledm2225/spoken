import SwiftUI

/// The shared frame every onboarding screen sits in: the header row, the
/// scrolling content and the button.
///
/// The button is drawn here and nowhere else, which is what makes it the same
/// size in the same place on all four screens. It is a sibling of the scroll
/// view rather than an inset over it, so at large type sizes overflowing
/// content stops above the button instead of showing through around it.
struct OnboardingScaffold<Content: View>: View {
    let step: OnboardingStep
    var isButtonEnabled: Bool = true
    let onButtonTap: () -> Void
    var onSkip: () -> Void = {}
    var onBack: () -> Void = {}
    @ViewBuilder let content: Content

    @ScaledMetric(relativeTo: .body) private var chevronSize: CGFloat = 14

    var body: some View {
        VStack(alignment: .leading, spacing: Space.l) {
            header
                .padding(.top, Space.s)

            ScrollView {
                content
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .scrollBounceBehavior(.basedOnSize)

            PrimaryButton(title: step.buttonTitle, isEnabled: isButtonEnabled, action: onButtonTap)
        }
        .padding(.horizontal, Space.xl)
        .padding(.bottom, Space.l)
    }

    /// Screen one has no Back, so the pills sit in the header row beside Skip.
    /// The later screens show Back and Skip, with the pills underneath.
    @ViewBuilder private var header: some View {
        if step.showsBack {
            VStack(alignment: .leading, spacing: Space.l) {
                HStack(spacing: Space.m) {
                    backButton.frame(maxWidth: .infinity, alignment: .leading)
                    skipButton.frame(maxWidth: .infinity, alignment: .trailing)
                }
                ProgressPills(current: step)
            }
        } else {
            HStack(spacing: Space.m) {
                ProgressPills(current: step)
                    .frame(maxWidth: .infinity, alignment: .leading)
                skipButton.frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }

    private var backButton: some View {
        Button(action: onBack) {
            HStack(spacing: Space.xs) {
                Image(systemName: "chevron.left")
                    .font(.system(size: chevronSize, weight: .medium))
                Text("Back")
                    .uiText(17)
            }
            .foregroundStyle(Palette.ink)
        }
        .accessibilityLabel("Back")
        .accessibilityAddTraits(.isButton)
    }

    @ViewBuilder private var skipButton: some View {
        if step.showsSkip {
            Button("Skip", action: onSkip)
                .uiText(17)
                .foregroundStyle(Palette.muted)
                .accessibilityLabel("Skip this step")
                .accessibilityAddTraits(.isButton)
        }
    }
}
