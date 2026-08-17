import SwiftUI

/// Where the learner lands once onboarding is done.
///
/// This step brings up the frame and the progress row, both driven by the goal
/// saved during onboarding. Step 8 adds the swipeable card stack in the space
/// below, and step 9 the floating actions bar.
struct HomeScreen: View {
    let settings: SettingsStore

    private var goal: DailyGoal { settings.dailyGoal ?? .default }

    var body: some View {
        VStack(alignment: .leading, spacing: Space.l) {
            ProgressRow(learned: 0, goal: goal)
                .reveal(index: 0)

            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal, Space.xl)
        .padding(.top, Space.l)
        .padding(.bottom, Space.l)
        .background {
            AmbientBackground()
        }
    }
}

#Preview {
    HomeScreen(settings: UserDefaultsSettingsStore())
}
