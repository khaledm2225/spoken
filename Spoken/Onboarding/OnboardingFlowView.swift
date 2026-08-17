import SwiftUI

/// Shows whichever onboarding screen the view model is on.
///
/// There is no `NavigationStack` and no push. Changing the step swaps the
/// content inside the shared scaffold, which is why the button never moves.
struct OnboardingFlowView: View {
    @State private var model: OnboardingViewModel

    init(settings: SettingsStore) {
        _model = State(initialValue: OnboardingViewModel(settings: settings))
    }

    var body: some View {
        OnboardingScaffold(
            step: model.step,
            isButtonEnabled: model.canAdvance,
            onButtonTap: { model.advance() },
            onSkip: { model.skip() },
            onBack: { model.goBack() }
        ) {
            switch model.step {
            case .welcome:
                WelcomeScreen()
            case .level:
                LevelScreen(selection: $model.level)
            case .interests, .dailyGoal:
                // Built in steps 6 and 7.
                Color.clear
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            // The welcome screen carries the stronger colour; it settles to the
            // softer set once the learner moves on.
            AmbientBackground(style: model.step == .welcome ? .welcome : .standard)
                .animation(.easeInOut(duration: 0.4), value: model.step)
        }
    }
}

#Preview {
    OnboardingFlowView(settings: UserDefaultsSettingsStore())
}
