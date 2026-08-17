import SwiftUI

/// Corner radii. Always continuous, never circular.
/// Radii stay fixed at every Dynamic Type size, so no scaled metric here.
enum Radius {
    static let card: CGFloat = 28
    static let chip: CGFloat = 20

    /// The one way to build a rounded rectangle in this app, so `.continuous`
    /// can never be forgotten at a call site.
    static func shape(_ radius: CGFloat) -> RoundedRectangle {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
    }
}
