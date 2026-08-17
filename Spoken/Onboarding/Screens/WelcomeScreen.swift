import SwiftUI

/// Onboarding screen one: what the app is, in two lines.
struct WelcomeScreen: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Space.xl) {
            WelcomeHero()
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
