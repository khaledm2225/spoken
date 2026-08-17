import SwiftUI

/// The background behind every screen: a flat base with three soft colour orbs
/// drifting off the edges.
///
/// The orbs are the fixed decorative geometry the layout rules allow a fixed
/// frame. They hold no text, so nothing here can clip or truncate, and placement
/// is by alignment rather than measurement so it holds at any screen width.
///
/// This is the only view in the app permitted to ignore safe areas.
struct AmbientBackground: View {
    var body: some View {
        Palette.background
            .overlay(alignment: .topTrailing) { Self.topRight.view }
            .overlay(alignment: .bottomLeading) { Self.bottomLeft.view }
            .overlay(alignment: .leading) { Self.centreLeft.view }
            .ignoresSafeArea()
            .accessibilityHidden(true)
    }

    // Diameters are generous on purpose: a heavy blur eats the edges of a
    // circle, so a small orb washes out to nothing. These sizes let each orb
    // hold its stated opacity through the blur.
    private static let topRight = Orb(
        colour: Palette.accent, opacity: 0.12,
        diameter: 460, blur: 90, offset: CGSize(width: 80, height: -120)
    )

    private static let bottomLeft = Orb(
        colour: Palette.orbLavender, opacity: 0.18,
        diameter: 520, blur: 100, offset: CGSize(width: -120, height: 140)
    )

    private static let centreLeft = Orb(
        colour: Palette.orbPink, opacity: 0.14,
        diameter: 440, blur: 110, offset: CGSize(width: -140, height: 0)
    )

    private struct Orb {
        let colour: Color
        let opacity: Double
        let diameter: CGFloat
        let blur: CGFloat
        let offset: CGSize

        var view: some View {
            Circle()
                .fill(colour.opacity(opacity))
                .frame(width: diameter, height: diameter)
                .blur(radius: blur)
                .offset(x: offset.width, y: offset.height)
        }
    }
}

#Preview {
    AmbientBackground()
}
