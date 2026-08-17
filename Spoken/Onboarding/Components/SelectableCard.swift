import SwiftUI

/// A tappable card with a title, a supporting line and an optional badge when
/// chosen. Screens 2 and 4 both use it, so a picked card looks and behaves the
/// same in both places.
///
/// The card has no fixed height: it grows from its padding and whatever it
/// holds, so it still reads at accessibility type sizes. It gives slightly under
/// the finger, and choosing it pops the badge in and warms the edge to accent.
struct SelectableCard<Detail: View>: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void
    @ViewBuilder var detail: Detail

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Space.xs) {
                HStack(alignment: .top, spacing: Space.m) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(title)
                            .uiText(20, .semibold)
                            .foregroundStyle(Palette.ink)
                        Text(subtitle)
                            .uiText(17)
                            .foregroundStyle(Palette.muted)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if isSelected {
                        SelectionBadge()
                            .transition(reduceMotion ? .opacity : .scale(scale: 0.7).combined(with: .opacity))
                    }
                }

                detail
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Space.m)
            .surfaceCard(cornerRadius: Radius.option, isSelected: isSelected)
        }
        .buttonStyle(.pressable)
        .animation(Motion.pop(reduceMotion: reduceMotion), value: isSelected)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

extension SelectableCard where Detail == EmptyView {
    init(title: String, subtitle: String, isSelected: Bool, action: @escaping () -> Void) {
        self.init(title: title, subtitle: subtitle, isSelected: isSelected, action: action) {
            EmptyView()
        }
    }
}

#Preview {
    ZStack {
        AmbientBackground()
        VStack(spacing: Space.s) {
            SelectableCard(
                title: Level.newLearner.title,
                subtitle: Level.newLearner.subtitle,
                isSelected: true,
                action: {}
            ) {
                WordTagRow(words: Level.newLearner.sampleWords)
            }

            SelectableCard(
                title: Level.gettingBetter.title,
                subtitle: Level.gettingBetter.subtitle,
                isSelected: false,
                action: {}
            ) {
                WordTagRow(words: Level.gettingBetter.sampleWords)
            }
        }
        .padding(Space.xl)
    }
}
