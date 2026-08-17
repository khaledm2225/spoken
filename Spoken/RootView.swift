import SwiftUI

/// Top level view. Owns the dependencies and decides which flow is showing:
/// onboarding until the learner has finished it, home from then on, including
/// on every later launch.
///
/// Each flow draws its own ambient background.
struct RootView: View {
    private let settings: SettingsStore
    @State private var hasFinishedOnboarding: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(settings: SettingsStore = UserDefaultsSettingsStore()) {
        self.settings = settings
        _hasFinishedOnboarding = State(initialValue: settings.hasFinishedOnboarding)
    }

    var body: some View {
        ZStack {
            if hasFinishedOnboarding {
                HomeScreen(settings: settings)
                    .transition(.opacity)
            } else {
                OnboardingFlowView(settings: settings) {
                    withAnimation(Motion.push(reduceMotion: reduceMotion)) {
                        hasFinishedOnboarding = true
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    RootView()
}
