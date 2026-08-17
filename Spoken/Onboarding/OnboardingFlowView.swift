import SwiftUI

/// Shows whichever onboarding screen the view model is on.
///
/// There is no `NavigationStack` and no push. Changing the step swaps the
/// content inside the shared scaffold, which is why the button never moves.
/// The swap itself is animated: the new screen slides in from the side the
/// learner is heading towards, and the old one slides out the other way.
struct OnboardingFlowView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var model: OnboardingViewModel
    @State private var isMovingForward = true
    @State private var isLeaving = false

    init(settings: SettingsStore) {
        _model = State(initialValue: OnboardingViewModel(settings: settings))
    }

    var body: some View {
        OnboardingScaffold(
            step: model.step,
            isButtonEnabled: model.canAdvance,
            onButtonTap: { move(forward: true) { model.advance() } },
            onSkip: { move(forward: true) { model.skip() } },
            onBack: { move(forward: false) { model.goBack() } }
        ) {
            // A ZStack keeps the outgoing screen laid out while it leaves, which
            // is what lets it slide rather than vanish.
            ZStack {
                screen
                    .id(model.step)
                    .transition(transition)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            // The welcome screen carries the stronger colour; it settles to the
            // softer set once the learner moves on.
            AmbientBackground(style: model.step == .welcome ? .welcome : .standard)
                .animation(Motion.push(reduceMotion: reduceMotion), value: model.step)
        }
    }

    @ViewBuilder private var screen: some View {
        switch model.step {
        case .welcome:
            WelcomeScreen(isSettled: !isLeaving)
        case .level:
            LevelScreen(selection: $model.level)
        case .interests, .dailyGoal:
            // Built in steps 6 and 7.
            Color.clear
        }
    }

    /// The incoming screen slides in over the one leaving, which stays put and
    /// settles back a little as it fades. Sliding both the same distance reads
    /// as a shove; letting the old one hang back gives the swap some depth and
    /// keeps the eye on the screen that is arriving.
    ///
    /// No screen width arithmetic: the arriving screen's slide comes from
    /// `.move`, and the departing one only scales and fades.
    private var transition: AnyTransition {
        guard !reduceMotion else { return .opacity }
        return .asymmetric(
            insertion: .move(edge: isMovingForward ? .trailing : .leading),
            removal: .scale(scale: 0.94).combined(with: .opacity)
        )
    }

    /// Records the direction and tells the current screen it is leaving first,
    /// then applies the change on the next turn of the run loop, so the outgoing
    /// screen has already been told which way to go, and has stopped any idle
    /// motion, before it slides.
    private func move(forward: Bool, _ change: @escaping () -> Void) {
        isMovingForward = forward
        isLeaving = true
        Task { @MainActor in
            withAnimation(Motion.push(reduceMotion: reduceMotion)) {
                change()
                isLeaving = false
            }
        }
    }
}

#Preview {
    OnboardingFlowView(settings: UserDefaultsSettingsStore())
}
