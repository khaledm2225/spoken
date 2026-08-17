import SwiftUI

/// The app's motion language: quiet and functional. Movement exists to show
/// where a screen came from and to soften a state change, nothing more. There
/// is no bounce, and nothing scales or springs, so the app reads as a tool
/// rather than a toy.
///
/// Every animation goes through here so Reduce Motion is honoured in one place:
/// movement becomes a plain crossfade.
enum Motion {
    /// A screen moving into place. `smooth` is a spring with the bounce taken
    /// out, so it eases in and stops, without wobbling.
    static let push = Animation.smooth(duration: 0.38)

    /// A state change with no movement behind it, such as a card becoming the
    /// chosen one. Short, and a plain ease rather than a spring.
    static let pop = Animation.easeInOut(duration: 0.18)

    /// A control acknowledging a touch.
    static let press = Animation.easeOut(duration: 0.12)

    /// The stand in for all of the above under Reduce Motion.
    static let crossfade = Animation.easeInOut(duration: 0.22)

    /// The hero cluster's idle float. Slow and shallow on purpose: it should
    /// only ever be caught out of the corner of the eye.
    static let drift = Animation.easeInOut(duration: 4.5)

    /// The pause between one element arriving and the next. Small enough to
    /// feel like one movement rather than a queue of them.
    static let beat: Double = 0.04

    /// The screen push, or a plain crossfade under Reduce Motion.
    static func push(reduceMotion: Bool) -> Animation {
        reduceMotion ? crossfade : push
    }

    /// The state change, or a plain crossfade under Reduce Motion.
    static func pop(reduceMotion: Bool) -> Animation {
        reduceMotion ? crossfade : pop
    }
}

/// Fades an element in, lifting it a few points, `index` beats after the first.
/// The lift is small and there is no scaling: it should read as the screen
/// settling, not as things flying in.
struct Reveal: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let index: Int
    @State private var isShown = false

    func body(content: Content) -> some View {
        content
            .opacity(isShown ? 1 : 0)
            .offset(y: isShown || reduceMotion ? 0 : Space.xs)
            .onAppear {
                let animation = reduceMotion
                    ? Motion.crossfade
                    : Motion.push.delay(Double(index) * Motion.beat)
                withAnimation(animation) { isShown = true }
            }
    }
}

/// Dims a button while it is held, so a tap is acknowledged without the control
/// moving or changing size.
struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.72 : 1)
            .animation(Motion.press, value: configuration.isPressed)
    }
}

extension View {
    /// Fades the view in, `index` beats after the first.
    func reveal(index: Int = 0) -> some View {
        modifier(Reveal(index: index))
    }
}

extension ButtonStyle where Self == PressableStyle {
    static var pressable: PressableStyle { PressableStyle() }
}
