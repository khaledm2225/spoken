import SwiftUI

/// The question and one supporting line that open onboarding screens two,
/// three and four.
struct ScreenHeading: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: Space.xs) {
            Text(title)
                // Scaled against largeTitle, not body: a headline scaled at the
                // body ratio would triple at AX5.
                .uiText(32, .bold, relativeTo: .largeTitle)
                .foregroundStyle(Palette.ink)

            Text(subtitle)
                .uiText(17)
                .foregroundStyle(Palette.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}

#Preview {
    ZStack {
        AmbientBackground()
        ScreenHeading(title: "How much English do you know?", subtitle: "Pick one to set your words")
            .padding(Space.xl)
    }
}
