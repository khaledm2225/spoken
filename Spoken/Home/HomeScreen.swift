import SwiftUI

/// Where the learner lands once onboarding is done: today's progress and the
/// deck of words to work through.
///
/// Step 9 adds the floating actions bar below the deck.
struct HomeScreen: View {
    @State private var model: HomeViewModel

    init(settings: SettingsStore, loader: WordsLoader = BundledWordsLoader()) {
        _model = State(initialValue: HomeViewModel(loader: loader, settings: settings))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Space.l) {
            ProgressRow(done: model.done, goal: model.goal)
                .reveal(index: 0)

            deck
        }
        .padding(.horizontal, Space.xl)
        .padding(.top, Space.l)
        .padding(.bottom, Space.l)
        .background {
            AmbientBackground()
        }
    }

    @ViewBuilder private var deck: some View {
        if model.loadFailed {
            message("The words could not be loaded.")
        } else if model.isFinished {
            message("That is every word for now. Well done.")
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
