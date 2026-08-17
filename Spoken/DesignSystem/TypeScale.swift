import SwiftUI

/// Every font in the app. SF Pro carries the interface, New York carries the
/// vocabulary words and nothing else.
///
/// Both helpers return `.system` fonts, which SwiftUI scales with Dynamic Type
/// automatically, so screens stay readable up to AX5 without extra work.
enum TypeScale {
    /// Interface text: titles, labels, buttons, captions.
    static func ui(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight)
    }

    /// Vocabulary words only. Never used for interface text.
    static func word(_ size: CGFloat, _ weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }
}
