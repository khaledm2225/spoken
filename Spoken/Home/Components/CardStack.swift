import SwiftUI

/// The deck on the home screen: three cards deep, the top one draggable.
///
/// Swipe left to skip, right to say you know it. The card follows the finger and
/// tilts as it goes. Cross a third of the card's width and a light tap fires
/// straight away, while the finger is still down, so the learner knows the swipe
/// has taken before they let go. Let go past that point and the card carries on
/// off the screen; let go short of it and it settles back.
struct CardStack: View {
    let model: HomeViewModel
    let onSwipe: (HomeViewModel.Swipe) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var drag: CGSize = .zero
    @State private var cardWidth: CGFloat = 0
    @State private var isPastThreshold = false

    /// The card on its way off the screen, drawn over a deck that has already
    /// moved on. Keeping it separate is what lets the next word be in place
    /// before this one has finished leaving.
    @State private var leaving: LeavingCard?

    /// How far the card must travel to count, as a share of its own width.
    private let commitShare: CGFloat = 0.35
    /// Degrees of tilt per point dragged.
    private let tiltPerPoint: Double = 0.05
    /// How far each card behind sits above the one in front.
    private let peek = Space.xxl + Space.m
    private let depthScales: [CGFloat] = [1, 0.92, 0.85]
    private let depthOpacities: [Double] = [1, 0.7, 0.45]

    private var threshold: CGFloat { max(1, cardWidth * commitShare) }

    var body: some View {
        ZStack {
            ForEach(Array(model.remaining.prefix(3).enumerated()).reversed(), id: \.element) { depth, word in
                card(word, depth: depth)
            }

            if let leaving {
                WordCard(word: leaving.word, example: model.example(for: leaving.word))
                    .aspectRatio(0.89, contentMode: .fit)
                    .offset(leaving.offset)
                    .rotationEffect(.degrees(leaving.offset.width * tiltPerPoint))
                    .allowsHitTesting(false)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // Reads the deck's width so the commit threshold can be a share of the
        // card rather than a hard coded distance. This measures for the gesture
        // only; the layout above sizes itself.
        .background {
            GeometryReader { proxy in
                Color.clear
                    .onAppear { cardWidth = proxy.size.width }
                    .onChange(of: proxy.size.width) { _, new in cardWidth = new }
            }
        }
        .sensoryFeedback(.impact(weight: .light), trigger: isPastThreshold) { _, crossed in
            crossed
        }
    }

    @ViewBuilder
    private func card(_ word: Word, depth: Int) -> some View {
        let isTop = depth == 0

        // Only the top card shows its word. The cards behind are blank, as the
        // design has them: a strip of their top edge is all that shows, and
        // printing the next word there would give away what is coming.
        Group {
            if isTop {
                WordCard(word: word, example: model.example(for: word))
            } else {
                Color.clear.cardSurface()
            }
        }
        .aspectRatio(0.89, contentMode: .fit)
        .scaleEffect(depthScales[min(depth, depthScales.count - 1)])
        .opacity(depthOpacities[min(depth, depthOpacities.count - 1)])
        .offset(y: -peek * CGFloat(depth))
        .offset(isTop ? drag : .zero)
        .rotationEffect(.degrees(isTop ? drag.width * tiltPerPoint : 0))
        .allowsHitTesting(isTop)
        .gesture(isTop ? dragGesture : nil)
        .accessibilityAddTraits(.isButton)
        .accessibilityAction(named: "Skip") { advance(.skip) }
        .accessibilityAction(named: "I know it") { advance(.knowIt) }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                drag = value.translation
                isPastThreshold = abs(value.translation.width) >= threshold
            }
            .onEnded { value in
                let committed = abs(value.translation.width) >= threshold
                // Cleared as the finger lifts either way, so the next drag can
                // cross the line again and tap afresh.
                isPastThreshold = false

                guard committed, let word = model.remaining.first else {
                    withAnimation(reduceMotion ? Motion.crossfade : Motion.settle) {
                        drag = .zero
                    }
                    return
                }

                throwOff(word, toTrailing: value.translation.width > 0, from: value.translation)
            }
    }

    /// Hands the card to the model straight away so the next word is already in
    /// place, then flies the old card the rest of the way out over the top of it.
    private func throwOff(_ word: Word, toTrailing: Bool, from translation: CGSize) {
        let swipe: HomeViewModel.Swipe = toTrailing ? .knowIt : .skip

        guard !reduceMotion else {
            withAnimation(Motion.crossfade) { advance(swipe) }
            return
        }

        leaving = LeavingCard(word: word, offset: translation)
        advance(swipe)

        withAnimation(Motion.flyOff) {
            leaving?.offset = CGSize(
                width: (toTrailing ? 1 : -1) * cardWidth * 2,
                height: translation.height
            )
        } completion: {
            leaving = nil
        }
    }

    /// Moves the deck on with animation switched off, so the next card is simply
    /// there rather than fading in behind the one leaving.
    private func advance(_ swipe: HomeViewModel.Swipe) {
        var instant = Transaction()
        instant.disablesAnimations = true
        withTransaction(instant) {
            onSwipe(swipe)
            drag = .zero
            isPastThreshold = false
        }
    }
}

/// A card mid flight, drawn above a deck that has already moved on.
private struct LeavingCard: Equatable {
    let word: Word
    var offset: CGSize
}
