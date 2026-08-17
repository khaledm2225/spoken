import SwiftUI

/// Corner radii. Always continuous, never circular.
/// Radii stay fixed at every Dynamic Type size, so no scaled metric here.
enum Radius {
    /// The hero card and the home word cards.
    static let card: CGFloat = 28
    /// The floating chips around the hero and the home actions bar.
    static let chip: CGFloat = 20
    /// The pick one cards on the level and daily goal screens. The mockups
    /// measure about thirteen points here, far tighter than the big cards.
    static let option: CGFloat = 12
    /// The small sample word tags inside a level card. The mockups measure
    /// about six points.
    static let tag: CGFloat = 6

    /// The one way to build a rounded rectangle in this app, so `.continuous`
    /// can never be forgotten at a call site.
    static func shape(_ radius: CGFloat) -> RoundedRectangle {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
    }
}
