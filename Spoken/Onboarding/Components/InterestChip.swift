import SwiftUI

/// One topic the learner can pick on screen three.
///
/// Unselected it is light floating glass; picked it fills with the accent and
/// grows a tick. The chip sizes itself from its word plus padding, so a longer
/// topic simply makes a wider chip.
struct InterestChip: View {
    let interest: Interest
    let isSelected: Bool
    let action: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .body) private var tickSize: CGFloat = 15

    var body: some View {
        Button(action: action) {
            HStack(spacing: Space.xs) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: tickSize, weight: .bold))
                        .transition(.opacity)
                }

                Text(interest.title)
                    .uiText(17, .medium)
            }
            .foregroundStyle(isSelected ? Palette.ctaLabel : Palette.ink)
            .padding(.horizontal, Space.m)
            .padding(.vertical, Space.s)
            .background {
                if isSelected {
                    Capsule().fill(Palette.accent)
                } else {
                    Capsule().fill(Palette.surface.opacity(0.15))
                        .overlay(Capsule().strokeBorder(Palette.surface.opacity(0.80), lineWidth: 1))
                }
            }
        }
        .buttonStyle(.pressable)
        .animation(Motion.pop(reduceMotion: reduceMotion), value: isSelected)
        .accessibilityLabel(interest.title)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

#Preview {
    ZStack {
        AmbientBackground()
        FlowLayout {
            InterestChip(interest: .football, isSelected: true) {}
            InterestChip(interest: .movies, isSelected: true) {}
            InterestChip(interest: .money, isSelected: false) {}
            InterestChip(interest: .travel, isSelected: false) {}
        }
        .padding(Space.xl)
    }
}
