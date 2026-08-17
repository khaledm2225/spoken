import SwiftUI

/// Top level view. Owns which flow the app is showing.
/// Step 4 replaces the body with the onboarding / home switch.
struct RootView: View {
    var body: some View {
        AmbientBackground()
    }
}

#Preview {
    RootView()
}
