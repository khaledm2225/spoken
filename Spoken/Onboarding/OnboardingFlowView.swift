import SwiftUI

/// Shows whichever onboarding screen the view model is on.
///
/// There is no `NavigationStack` and no push. Changing the step swaps the
/// content inside the shared scaffold, which is why the button never moves.
/// The swap itself is animated: the new screen slides in from the side the
/// learner is heading towards, and the old one slides out the other way.
struct OnboardingFlowView: View {
    /// Called once the learner finishes the last screen and the choices are saved.
    private let onFinished: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var model: OnboardingViewModel
    @State private var isMovingForward = true
    @State private var isLeaving = false

    init(settings: SettingsStore, onFinished: @escaping () -> Void = {}) {
        _model = State(initialValue: OnboardingViewModel(settings: settings))
        self.onFinished = onFinished
    }

    var body: some View {
        OnboardingScaffold(
            step: model.step,
            isButtonEnabled: model.canAdvance,
            onButtonTap: finishOrAdvance,
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
        case .interests:
            InterestsScreen(selection: $model.interests)
        case .dailyGoal:
            DailyGoalScreen(selection: $model.dailyGoal)
        }
    }

    /// The arriving screen fades in while nudging over from the direction of
    /// travel; the one leaving just fades.
    ///
    /// The nudge is a short fixed distance rather than a full width slide. A
    /// full slide drags a whole screen of text across a second screen of text,
    /// which reads as busy and leaves the two smeared together halfway through.
    /// A few points is enough to say which way the flow went.
    private var transition: AnyTransition {
        guard !reduceMotion else { return .opacity }
        let nudge = isMovingForward ? Space.l : -Space.l
        return .asymmetric(
            insertion: .modifier(
                active: NudgedScreen(offset: nudge),
                identity: NudgedScreen(offset: 0)
            ),
            removal: .opacity
        )
    }

    /// The last screen commits instead of moving on. Saving is the view model's
    /// job; deciding what to show next is this view's.
    private func finishOrAdvance() {
        if model.isOnLastStep {
            model.finish()
            onFinished()
        } else {
            move(forward: true) { model.advance() }
        }
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

/// The arriving half of the swap: a short sideways nudge plus a fade. The
/// distance is a fixed, decorative one, not a share of the screen's width.
private struct NudgedScreen: ViewModifier {
    let offset: CGFloat

    func body(content: Content) -> some View {
        content
            .opacity(offset == 0 ? 1 : 0)
            .offset(x: offset)
    }
}

#Preview {
    OnboardingFlowView(settings: UserDefaultsSettingsStore())
}
