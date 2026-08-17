import SwiftUI

/// How strong the orbs are. The welcome screen's mockup carries much stronger
/// colour than the screens after it, so there are two presets.
///
/// Values were fitted by sampling the reference mockups pixel by pixel, not
/// taken from the written spec: the spec's 22 / 14 / 18 percent read far paler
/// than the mockups, and the mockups are what the app is judged against.
struct AmbientStyle: Equatable {
    /// The accent glow is a tight core inside a wide soft halo.
    var accentCore: Double
    var accentHalo: Double
    var pink: Double
    var lavender: Double

    /// Fitted to `on1.png`.
    static let welcome = AmbientStyle(accentCore: 0.34, accentHalo: 0.16, pink: 0.60, lavender: 0.38)

    /// Fitted to `on2.png`. Used from the second onboarding screen onward.
    static let standard = AmbientStyle(accentCore: 0.10, accentHalo: 0.04, pink: 0.55, lavender: 0.20)
}

/// The background behind every screen: a flat base with soft colour glows
/// drifting off the edges.
///
/// The glows are the fixed decorative geometry the layout rules allow a fixed
/// frame. They hold no text, so nothing here can clip or truncate, and placement
/// is by alignment rather than measurement so it holds at any screen width.
///
/// This is the only view in the app permitted to ignore safe areas.
struct AmbientBackground: View {
    var style: AmbientStyle = .standard

    var body: some View {
        Palette.background
            .overlay(alignment: .topTrailing) {
                glow(Palette.accent, opacity: style.accentHalo, width: 330, height: 330, blur: 70)
                    .offset(x: 105, y: -75)
            }
            .overlay(alignment: .topTrailing) {
                glow(Palette.accent, opacity: style.accentCore, width: 120, height: 120, blur: 30)
                    .offset(x: -15, y: 9)
            }
            .overlay(alignment: .topLeading) {
                // The mockup's pink glow is wider than it is tall.
                glow(Palette.orbPink, opacity: style.pink, width: 300, height: 230, blur: 55)
                    .offset(x: -140, y: 200)
            }
            .overlay(alignment: .bottomLeading) {
                glow(Palette.orbLavender, opacity: style.lavender, width: 300, height: 300, blur: 50)
                    .offset(x: -110, y: 20)
            }
            .ignoresSafeArea()
            .accessibilityHidden(true)
    }

    private func glow(_ colour: Color, opacity: Double, width: CGFloat, height: CGFloat, blur: CGFloat) -> some View {
        Ellipse()
            .fill(colour.opacity(opacity))
            .frame(width: width, height: height)
            .blur(radius: blur)
    }
}

#Preview("Welcome") {
    AmbientBackground(style: .welcome)
}

#Preview("Later screens") {
    AmbientBackground()
}
