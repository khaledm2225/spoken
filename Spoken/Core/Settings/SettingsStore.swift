import Foundation

/// Everything the learner chose during onboarding, kept between launches.
/// A protocol so it can be handed in through an init and swapped for an
/// in-memory version, with no singleton anywhere.
protocol SettingsStore: AnyObject {
    var level: Level? { get set }
    var interests: Set<Interest> { get set }
    var dailyGoal: DailyGoal? { get set }
    var hasFinishedOnboarding: Bool { get set }
}

/// Stores the choices in `UserDefaults`.
final class UserDefaultsSettingsStore: SettingsStore {
    private enum Key {
        static let level = "settings.level"
        static let interests = "settings.interests"
        static let dailyGoal = "settings.dailyGoal"
        static let hasFinishedOnboarding = "settings.hasFinishedOnboarding"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var level: Level? {
        get { defaults.string(forKey: Key.level).flatMap(Level.init(rawValue:)) }
        set { defaults.set(newValue?.rawValue, forKey: Key.level) }
    }

    var interests: Set<Interest> {
        get {
            let raw = defaults.stringArray(forKey: Key.interests) ?? []
            return Set(raw.compactMap(Interest.init(rawValue:)))
        }
        set {
            defaults.set(newValue.map(\.rawValue).sorted(), forKey: Key.interests)
        }
    }

    var dailyGoal: DailyGoal? {
        get {
            guard defaults.object(forKey: Key.dailyGoal) != nil else { return nil }
            return DailyGoal(rawValue: defaults.integer(forKey: Key.dailyGoal))
        }
        set { defaults.set(newValue?.rawValue, forKey: Key.dailyGoal) }
    }

    var hasFinishedOnboarding: Bool {
        get { defaults.bool(forKey: Key.hasFinishedOnboarding) }
        set { defaults.set(newValue, forKey: Key.hasFinishedOnboarding) }
    }
}
