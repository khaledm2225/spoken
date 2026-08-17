import SwiftUI

/// Where the learner lands once onboarding is done: today's progress, the deck
/// of words to work through, and the actions bar floating under it.
struct HomeScreen: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var model: HomeViewModel
    private let speaker: WordSpeaker

    init(
        settings: SettingsStore,
        loader: WordsLoader = BundledWordsLoader(),
        speaker: WordSpeaker = SystemWordSpeaker()
    ) {
        _model = State(initialValue: HomeViewModel(loader: loader, settings: settings))
        self.speaker = speaker
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Space.l) {
            ProgressRow(done: model.done, goal: model.goal)
                .reveal(index: 0)

            deck

            ActionsBar(
                canUndo: model.canUndo,
                isSaved: model.topWord.map(model.isSaved) ?? false,
                onUndo: { withAnimation(Motion.pop(reduceMotion: reduceMotion)) { model.undo() } },
                onSpeak: { if let word = model.topWord { speaker.speak(word.text) } },
                onSave: { if let word = model.topWord { model.toggleSaved(word) } }
            )
            .reveal(index: 2)
        }
        .padding(.horizontal, Space.xl)
        .padding(.top, Space.l)
        .padding(.bottom, Space.l)
        .background {
            AmbientBackground()
        }
        // Only a restore taps back: the index going down means undo, and a
        // swipe forward already tapped when it crossed the commit threshold.
        .sensoryFeedback(.impact(weight: .light), trigger: model.index) { old, new in
            new < old
        }
        .sensoryFeedback(.impact(weight: .light), trigger: model.saved)
    }

    @ViewBuilder private var deck: some View {
        if model.loadFailed {
            message("The words could not be loaded.")
        } else if model.isFinished {
            message("That is every word for today. Well done.")
        } else {
            CardStack(model: model) { swipe in
                model.commit(swipe)
            }
            .reveal(index: 1)
        }
    }

    private func message(_ text: String) -> some View {
        Text(text)
            .uiText(17)
            .foregroundStyle(Palette.muted)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HomeScreen(settings: UserDefaultsSettingsStore())
}
