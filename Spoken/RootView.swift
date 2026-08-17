import SwiftUI

/// Top level view. Owns the dependencies and decides which flow is showing.
/// Each flow draws its own ambient background. Step 7 adds the handoff from
/// onboarding to home.
struct RootView: View {
    private let settings: SettingsStore

    init(settings: SettingsStore = UserDefaultsSettingsStore()) {
        self.settings = settings
    }

    var body: some View {
        OnboardingFlowView(settings: settings)
    }
}

#Preview {
    RootView()
}
