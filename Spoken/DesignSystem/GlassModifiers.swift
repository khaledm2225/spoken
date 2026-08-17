import SwiftUI

/// Apple's guidance is that material belongs on elements floating above content,
/// never on the content itself. These two modifiers keep that line visible in
/// the code: reach for `floatingGlass` and you are saying "this floats".
///
/// Neither draws a shadow. The app has no shadows anywhere.
extension View {
    /// Floating elements only: the welcome hero cluster and the home actions bar.
    func floatingGlass(cornerRadius: CGFloat = Radius.card) -> some View {
        let shape = Radius.shape(cornerRadius)
        return background(.ultraThinMaterial, in: shape)
            .overlay(shape.strokeBorder(Palette.hairline, lineWidth: 1))
    }

    /// Content surfaces: level cards, interest chips, goal cards, word cards.
    func surfaceCard(cornerRadius: CGFloat = Radius.card) -> some View {
        let shape = Radius.shape(cornerRadius)
        return background(Palette.surface, in: shape)
            .overlay(shape.strokeBorder(Palette.hairline, lineWidth: 1))
    }
}

#Preview("Glass") {
    ZStack {
        AmbientBackground()
        VStack(spacing: Space.l) {
            Text("Floating glass")
                .font(TypeScale.ui(17, .semibold))
                .foregroundStyle(Palette.ink)
                .padding(Space.l)
                .frame(maxWidth: .infinity)
                .floatingGlass()

            Text("Content surface")
                .font(TypeScale.ui(17, .semibold))
                .foregroundStyle(Palette.ink)
                .padding(Space.l)
                .frame(maxWidth: .infinity)
                .surfaceCard()
        }
        .padding(Space.l)
    }
}
