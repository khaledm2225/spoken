import Foundation

/// The four onboarding screens, in order.
///
/// The flow is driven by this enum rather than by navigation pushes, so one
/// value always answers "where is the learner right now".
enum OnboardingStep: Int, CaseIterable, Identifiable, Hashable {
    case welcome
    case level
    case interests
    case dailyGoal

    var id: Int { rawValue }

    /// Position in the progress row.
    var index: Int { rawValue }

    /// The last screen commits the choices, so it offers no way past them.
    var showsSkip: Bool { self != .dailyGoal }

    /// Screen one has nothing behind it.
    var showsBack: Bool { self != .welcome }

    var buttonTitle: String {
        self == .dailyGoal ? "Start learning" : "Continue"
    }

    var next: OnboardingStep? { OnboardingStep(rawValue: rawValue + 1) }

    var previous: OnboardingStep? { OnboardingStep(rawValue: rawValue - 1) }
}
