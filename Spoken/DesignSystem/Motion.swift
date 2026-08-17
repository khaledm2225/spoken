import SwiftUI

/// The app's motion language: unhurried and settled. Movements are long enough
/// to read, and springs are damped almost to the point of not bouncing, so
/// things glide into place instead of snapping or wobbling.
///
/// Every animation goes through here so Reduce Motion is honoured in one place:
/// movement becomes a plain crossfade.
enum Motion {
    /// A screen moving into place. Long and smooth, with only the faintest
    /// settle at the end.
    static let push = Animation.spring(duration: 0.62, bounce: 0.04)

    /// A badge or a chosen card arriving. A little softer bounce than the push,
    /// still far short of springy.
    static let pop = Animation.spring(duration: 0.5, bounce: 0.12)

    /// A card giving under the finger. Short, because it tracks a live touch.
    static let press = Animation.spring(duration: 0.3, bounce: 0.0)

    /// The stand in for all of the above under Reduce Motion.
    static let crossfade = Animation.easeInOut(duration: 0.3)

    /// The hero cluster's endless idle float. Slow on purpose: it should be
    /// noticed only out of the corner of the eye.
    static let drift = Animation.easeInOut(duration: 3.6)

    /// The pause between one element arriving and the next. Wide enough to read
    /// as a sequence rather than a flicker.
    static let beat: Double = 0.09

    /// The screen push, or a plain crossfade under Reduce Motion.
    static func push(reduceMotion: Bool) -> Animation {
        reduceMotion ? crossfade : push
    }

    /// The selection pop, or a plain crossfade under Reduce Motion.
    static func pop(reduceMotion: Bool) -> Animation {
        reduceMotion ? crossfade : pop
    }
}

/// Fades an element in from just below its resting place, one beat later for
/// each step of `index`, so a screen's contents arrive in sequence rather than
/// all at once. Under Reduce Motion the element only fades.
struct Reveal: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let index: Int
    @State private var isShown = false

    func body(content: Content) -> some View {
        content
            .opacity(isShown ? 1 : 0)
            .offset(y: isShown || reduceMotion ? 0 : Space.m)
            .onAppear {
                let animation = reduceMotion
                    ? Motion.crossfade
                    : Motion.push.delay(Double(index) * Motion.beat)
                withAnimation(animation) { isShown = true }
            }
    }
}

/// Scales a button down a touch while it is pressed, so a card feels like it
/// gives under the finger.
struct PressableStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.98 : 1)
            .animation(Motion.press, value: configuration.isPressed)
    }
}

extension View {
    /// Fades the view in from just below, `index` beats after the first.
    func reveal(index: Int = 0) -> some View {
        modifier(Reveal(index: index))
    }
}

extension ButtonStyle where Self == PressableStyle {
    static var pressable: PressableStyle { PressableStyle() }
}
