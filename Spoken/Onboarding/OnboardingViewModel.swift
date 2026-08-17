import Foundation

/// Drives the onboarding flow: which screen is showing and what the learner
/// has chosen so far.
///
/// It never navigates. It moves an enum forward and back, and the views decide
/// what to draw for each value. Step 7 adds the write to the settings store.
@Observable
final class OnboardingViewModel {
    private(set) var step: OnboardingStep = .welcome

    var level: Level?
    var interests: Set<Interest> = []
    var dailyGoal: DailyGoal = .default

    private let settings: SettingsStore

    init(settings: SettingsStore) {
        self.settings = settings
    }

    /// Whether the button at the bottom of the current screen can be tapped.
    /// Screens 2 and 4 need a choice first.
    var canAdvance: Bool {
        switch step {
        case .welcome: true
        case .level: level != nil
        case .interests: !interests.isEmpty
        case .dailyGoal: true
        }
    }

    func advance() {
        guard canAdvance, let next = step.next else { return }
        step = next
    }

    /// Skip moves past the current screen without recording a choice.
    func skip() {
        guard let next = step.next else { return }
        step = next
    }

    func goBack() {
        guard let previous = step.previous else { return }
        step = previous
    }
}
