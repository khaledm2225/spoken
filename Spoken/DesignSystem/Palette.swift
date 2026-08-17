import SwiftUI

/// Every colour in the app. No view names a colour outside this file.
enum Palette {
    static let background = Color(hex: 0xF1EEFA)
    static let surface = Color(hex: 0xFBFAFF)
    static let ink = Color(hex: 0x161327)
    static let accent = Color(hex: 0x6C5CE0)
    static let ctaLabel = Color(hex: 0xF5F3FF)

    static let muted = ink.opacity(0.55)
    static let hairline = ink.opacity(0.12)

    /// Ambient background orbs. Decorative only, never used for content.
    static let orbLavender = Color(hex: 0xA79BF0)
    static let orbPink = Color(hex: 0xF0C9E0)
}
