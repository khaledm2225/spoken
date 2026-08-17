import SwiftUI

/// The filled accent circle with a tick that marks a chosen card.
///
/// The circle is an icon, so it scales with Dynamic Type through `@ScaledMetric`
/// rather than sitting at a fixed size.
struct SelectionBadge: View {
    @ScaledMetric(relativeTo: .body) private var diameter: CGFloat = 28

    var body: some View {
        Circle()
            .fill(Palette.accent)
            .frame(width: diameter, height: diameter)
            .overlay {
                Image(systemName: "checkmark")
                    .font(.system(size: diameter * 0.45, weight: .bold))
                    .foregroundStyle(Palette.ctaLabel)
            }
            .accessibilityHidden(true)
    }
}

#Preview {
    ZStack {
        AmbientBackground()
        SelectionBadge()
    }
}
