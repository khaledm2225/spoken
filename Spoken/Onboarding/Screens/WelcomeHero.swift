import SwiftUI

/// The floating word cluster on the welcome screen: one large glass card with a
/// word on it, and four small tilted chips overlapping its corners.
///
/// This is decoration. It is hidden from VoiceOver, and its type size is capped
/// so the cluster keeps its shape instead of reflowing at accessibility sizes.
/// Every movement is on the Y axis only, and all of it stops under Reduce Motion.
struct WelcomeHero: View {
    /// The idle drift runs while the screen is settled. It is paused while the
    /// screen slides away, because a child that keeps animating on its own
    /// clock ignores the slide and jumps.
    var isDrifting = true

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var hasAppeared = false

    private struct Chip: Identifiable {
        let id = UUID()
        let text: String
        let place: CGSize
        let tilt: Double
        let drift: CGFloat
        let delay: Double
    }

    /// Positions are offsets from the card centre, transcribed from the design.
    /// The chips all lean the same way, only slightly, with the top left one
    /// leaning most.
    private static let chips = [
        Chip(text: "happy", place: CGSize(width: -111, height: -125), tilt: -4, drift: 3, delay: 0.10),
        Chip(text: "begin", place: CGSize(width: 111, height: -99), tilt: -1, drift: -3, delay: 0.18),
        Chip(text: "brave", place: CGSize(width: -117, height: 108), tilt: -1, drift: 3, delay: 0.26),
        Chip(text: "quiet", place: CGSize(width: 93, height: 129), tilt: -1, drift: -3, delay: 0.34)
    ]

    var body: some View {
        ZStack {
            card
            ForEach(Self.chips) { chip in
                chipView(chip)
            }
        }
        // The chips hang past the card on offsets, which do not grow the stack.
        // This reserves the room they need so nothing is cut off.
        .padding(.vertical, Space.xl)
        .dynamicTypeSize(...DynamicTypeSize.large)
        .accessibilityHidden(true)
        .onAppear { hasAppeared = true }
    }

    private var card: some View {
        VStack(spacing: Space.s) {
            Text("light")
                .wordText(68, .regular)
                .foregroundStyle(Palette.ink)

            Text("NOUN")
                .uiText(13, .medium)
                .tracking(4)
                .foregroundStyle(Palette.muted)

            Text("the sun gives us light")
                .uiText(15)
                .foregroundStyle(Palette.muted)
        }
        .padding(.horizontal, Space.xxl)
        .padding(.vertical, Space.xxl + Space.xs)
        .floatingGlass(style: .card)
        .drifting(by: 2, delay: 0, appeared: hasAppeared, isStill: reduceMotion || !isDrifting)
    }

    private func chipView(_ chip: Chip) -> some View {
        Text(chip.text)
            .uiText(17, .semibold)
            .foregroundStyle(Palette.ink)
            .padding(Space.m)
            .floatingGlass(cornerRadius: Radius.chip)
            .rotationEffect(.degrees(chip.tilt))
            .offset(chip.place)
            .drifting(by: chip.drift, delay: chip.delay, appeared: hasAppeared, isStill: reduceMotion || !isDrifting)
    }
}

private extension View {
    /// Fades and lifts the view in, then drifts it slowly up and down forever.
    /// `isStill` drops the drift: under Reduce Motion, and while the screen is
    /// on its way out.
    @ViewBuilder
    func drifting(by amount: CGFloat, delay: Double, appeared: Bool, isStill: Bool) -> some View {
        let entered = opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : Space.m)
            .animation(isStill ? nil : Motion.push.delay(delay), value: appeared)

        if isStill {
            entered
        } else {
            PhaseAnimator([false, true]) { isUp in
                entered.offset(y: isUp ? amount : -amount)
            } animation: { _ in
                Motion.drift
            }
        }
    }
}

#Preview {
    ZStack {
        AmbientBackground(style: .welcome)
        WelcomeHero()
    }
}
