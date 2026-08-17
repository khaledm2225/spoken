import SwiftUI

/// Onboarding screen one: what the app is, in two lines.
struct WelcomeScreen: View {
    /// Passed down to the hero: the drift pauses while the screen slides away.
    var isSettled = true

    var body: some View {
        VStack(alignment: .leading, spacing: Space.xl) {
            WelcomeHero(isDrifting: isSettled)
                .frame(maxWidth: .infinity)
                .padding(.top, Space.xxl)
                .padding(.bottom, Space.xl)

            VStack(alignment: .leading, spacing: Space.s) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("New words,")
                        .foregroundStyle(Palette.ink)
                    Text("made simple.")
                        .foregroundStyle(Palette.accent)
                }
                // Scaled against largeTitle, not body: a headline scaled at the
                // body ratio would triple at AX5.
                .uiText(42, .bold, relativeTo: .largeTitle)

                Text("Learn five easy words a day")
                    .uiText(17)
                    .foregroundStyle(Palette.muted)
            }
            // Arrives after the hero cluster has settled.
            .reveal(index: 5)
        }
    }
}

#Preview {
    ZStack {
        AmbientBackground(style: .welcome)
        WelcomeScreen()
            .padding(Space.xl)
    }
}
