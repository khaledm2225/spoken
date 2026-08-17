import SwiftUI

/// Every font in the app. SF Pro carries the interface, New York carries the
/// vocabulary words and nothing else.
///
/// These are view modifiers rather than plain `Font` values on purpose.
/// `Font.system(size:)` is a fixed size and does not grow with Dynamic Type, so
/// a screen built on it looks identical at AX5. Running the size through
/// `@ScaledMetric` keeps the designed size at the default setting and scales it
/// from there, which is what the design and the accessibility requirement both
/// need.
enum TypeScale {
    /// Interface text: titles, labels, buttons, captions.
    static func ui(
        _ size: CGFloat,
        _ weight: Font.Weight = .regular,
        relativeTo style: Font.TextStyle = .body
    ) -> ScaledFont {
        ScaledFont(size: size, weight: weight, design: .default, relativeTo: style)
    }

    /// Vocabulary words only. Never used for interface text.
    static func word(
        _ size: CGFloat,
        _ weight: Font.Weight = .semibold,
        relativeTo style: Font.TextStyle = .largeTitle
    ) -> ScaledFont {
        ScaledFont(size: size, weight: weight, design: .serif, relativeTo: style)
    }
}

/// Applies a system font whose point size tracks Dynamic Type.
struct ScaledFont: ViewModifier {
    @ScaledMetric private var size: CGFloat
    private let weight: Font.Weight
    private let design: Font.Design

    init(size: CGFloat, weight: Font.Weight, design: Font.Design, relativeTo style: Font.TextStyle) {
        _size = ScaledMetric(wrappedValue: size, relativeTo: style)
        self.weight = weight
        self.design = design
    }

    func body(content: Content) -> some View {
        content.font(.system(size: size, weight: weight, design: design))
    }
}

extension View {
    /// Interface text, sized from the design and scaled by Dynamic Type.
    func uiText(
        _ size: CGFloat,
        _ weight: Font.Weight = .regular,
        relativeTo style: Font.TextStyle = .body
    ) -> some View {
        modifier(TypeScale.ui(size, weight, relativeTo: style))
    }

    /// Vocabulary words, in the serif face.
    func wordText(
        _ size: CGFloat,
        _ weight: Font.Weight = .semibold,
        relativeTo style: Font.TextStyle = .largeTitle
    ) -> some View {
        modifier(TypeScale.word(size, weight, relativeTo: style))
    }
}
