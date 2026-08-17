import SwiftUI

/// The floating bar under the deck: take a swipe back, hear the word, keep it.
///
/// This is one of the two places in the app that uses material, per the glass
/// rule: it floats over the deck rather than being part of it.
struct ActionsBar: View {
    let canUndo: Bool
    let isSaved: Bool
    let onUndo: () -> Void
    let onSpeak: () -> Void
    let onSave: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var typeSize
    @ScaledMetric(relativeTo: .body) private var iconSize: CGFloat = 20

    var body: some View {
        HStack(spacing: Space.m) {
            action(
                "arrow.uturn.backward",
                label: "Undo last swipe",
                tint: Palette.ink,
                action: onUndo
            )
            .opacity(canUndo ? 1 : 0.35)
            .disabled(!canUndo)
            .frame(maxWidth: .infinity)

            // The middle keeps its natural width so its name is never squeezed;
            // the two icons share whatever is left on either side.
            speak

            action(
                isSaved ? "heart.fill" : "heart",
                label: isSaved ? "Remove saved word" : "Save word",
                tint: isSaved ? Palette.accent : Palette.ink,
                action: onSave
            )
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, Space.m)
        .padding(.vertical, Space.m)
        .floatingGlass(cornerRadius: .infinity)
    }

    /// The middle action carries its name, as the mockup has it. At the largest
    /// type sizes the name no longer fits beside two other buttons, so it drops
    /// to the icon alone rather than being squeezed out of sight.
    private var speak: some View {
        Button(action: onSpeak) {
            HStack(spacing: Space.xs) {
                speakIcon
                // The name is in the design and stays at normal sizes. At
                // accessibility sizes it will not fit beside two other buttons,
                // so the icon carries it alone; VoiceOver still reads the label.
                if !typeSize.isAccessibilitySize {
                    Text("Speak")
                        .uiText(17, .medium)
                        .fixedSize()
                }
            }
            .foregroundStyle(Palette.ink)
        }
        .buttonStyle(.pressable)
        .accessibilityLabel("Speak the word")
        .accessibilityAddTraits(.isButton)
    }

    private var speakIcon: some View {
        Image(systemName: "speaker.wave.2")
            .font(.system(size: iconSize, weight: .medium))
    }

    private func action(
        _ symbol: String,
        label: String,
        tint: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: iconSize, weight: .medium))
                .foregroundStyle(tint)
                .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(.pressable)
        .accessibilityLabel(label)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    ZStack {
        AmbientBackground()
        VStack(spacing: Space.l) {
            ActionsBar(canUndo: false, isSaved: false, onUndo: {}, onSpeak: {}, onSave: {})
            ActionsBar(canUndo: true, isSaved: true, onUndo: {}, onSpeak: {}, onSave: {})
        }
        .padding(Space.xl)
    }
}
