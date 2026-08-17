# Spoken

Rebuild of Vocabulary's onboarding and home swipe flow. SwiftUI, iOS 17.

| Welcome | Level | Interests | Daily goal | Home |
|---|---|---|---|---|
| <img src="Screenshots/1-welcome.png" width="160"> | <img src="Screenshots/2-level.png" width="160"> | <img src="Screenshots/3-interests.png" width="160"> | <img src="Screenshots/4-daily-goal.png" width="160"> | <img src="Screenshots/5-home.png" width="160"> |

## Running it

Xcode 15+. Open `Spoken.xcodeproj`, run. No packages, no configuration.

## Architecture

A single app target, with folders rather than Swift packages marking the boundaries between the
design system, the core models and the two flows. The seams are protocols injected through `init`:
`WordsLoader` supplies the vocabulary, `SettingsStore` keeps the learner's choices, and neither has
a singleton behind it, so any screen can be built with a stand-in. Views follow MVVM with
`@Observable` view models that hold state and never navigate; onboarding is driven entirely by an
`OnboardingStep` enum rather than a navigation stack, which is what keeps the Continue button in
exactly the same place on all four screens. There are no third-party dependencies, and the whole
interface is drawn in code, with no image assets in the bundle.

## Design decisions

- iOS 17 as the minimum, for `.sensoryFeedback` and `PhaseAnimator`.
- Glass is reserved for floating layers, per Apple's guidance: the welcome hero and the home
  actions bar. Content surfaces are tinted, never material.
- Light mode is locked, and every screen sits on the same ambient orb background.
- The swipe haptic fires at the commit threshold, while the finger is still down, rather than on
  release, so the swipe is confirmed before you let go. This is the Squad Busters pattern.
- Motion is quiet by design: no bounce, no scaling, and every animation degrades to a crossfade
  under Reduce Motion.

## Personal touch

- **Undo** recovers a mistapped swipe, the most common complaint in the original app's App Store
  reviews. It restores the card, rolls the day's count back and taps lightly to confirm.
- **The onboarding choices visibly shape the content.** Example sentences are drawn from the
  interests picked on screen three and tagged on every card, so a learner who chose Football reads
  "The brave player stayed calm." under `from your pick: Football`.

## Accessibility

Dynamic Type through to AX5, VoiceOver cards grouped into a single element with custom actions, and
Reduce Motion honoured throughout.
