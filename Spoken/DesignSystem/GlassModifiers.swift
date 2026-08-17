import SwiftUI

/// How a piece of floating glass is washed and edged. Both values were sampled
/// from the reference mockups.
///
/// The material alone reads grey on the lavender background. The mockups' glass
/// is lighter than what sits behind it and lighter still along its top edge, so
/// a wash of the surface colour, fading downward, goes over the one material
/// layer. It is a tint, not a second material: glass is never stacked.
struct GlassStyle {
    /// Strength of the surface wash at the top and bottom of the shape.
    var washTop: Double
    var washBottom: Double
    /// Strength of the one point edge line.
    var edge: Double

    /// Small floating pieces: the welcome chips and the home actions bar.
    static let chip = GlassStyle(washTop: 0.50, washBottom: 0.10, edge: 0.90)

    /// The large welcome card, which the mockup leaves nearly see through.
    static let card = GlassStyle(washTop: 0.35, washBottom: 0.15, edge: 0.40)
}

/// Apple's guidance is that material belongs on elements floating above content,
/// never on the content itself. These two modifiers keep that line visible in
/// the code: reach for `floatingGlass` and you are saying "this floats".
///
/// Neither draws a shadow. The app has no shadows anywhere.
extension View {
    /// Floating elements only: the welcome hero cluster and the home actions bar.
    func floatingGlass(cornerRadius: CGFloat = Radius.card, style: GlassStyle = .chip) -> some View {
        let shape = Radius.shape(cornerRadius)
        let wash = LinearGradient(
            colors: [Palette.surface.opacity(style.washTop), Palette.surface.opacity(style.washBottom)],
            startPoint: .top,
            endPoint: .bottom
        )
        return background {
            shape.fill(.ultraThinMaterial)
            shape.fill(wash)
        }
        .overlay(shape.strokeBorder(Palette.surface.opacity(style.edge), lineWidth: 1))
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
        AmbientBackground(style: .welcome)
        VStack(spacing: Space.l) {
            Text("Floating glass, chip")
                .uiText(17, .semibold)
                .foregroundStyle(Palette.ink)
                .padding(Space.l)
                .frame(maxWidth: .infinity)
                .floatingGlass()

            Text("Floating glass, card")
                .uiText(17, .semibold)
                .foregroundStyle(Palette.ink)
                .padding(Space.l)
                .frame(maxWidth: .infinity)
                .floatingGlass(style: .card)

            Text("Content surface")
                .uiText(17, .semibold)
                .foregroundStyle(Palette.ink)
                .padding(Space.l)
                .frame(maxWidth: .infinity)
                .surfaceCard()
        }
        .padding(Space.l)
    }
}
