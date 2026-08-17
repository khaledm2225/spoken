# Final report

Notes for Khaled, not for the reviewers.

## Steps

| Step | Status | Commits |
|---|---|---|
| 1 Xcode project, git, gitignore | done | `397b984` |
| 2 DesignSystem tokens, ambient background | done | `ff8bbb9`, `c77a173` |
| 3 Core models, words loader, settings store | done | `a4723bb` |
| 4 Welcome screen, view model, step enum, RootView | done | `b9ad693` |
| 5 Level screen | done | `3481159`, `df2727f`, `89c775c` |
| 6 Interests screen | done | `0535a41` |
| 7 Daily goal, persistence, handoff to home | done | `a145473`, `3fc11cc` |
| 8 Card stack, gesture, threshold haptic, fly off | done | `2a0befc`, `c306557` |
| 9 Actions bar: undo, speak, save | done | `971e475` |
| 10 Accessibility essentials | done | `6fcbe1b` |
| 10.5 Adaptive layout audit and fixes | done | `e5df024` |
| 11 README, screenshots, this report | done | see final commit |

Nothing was skipped and the failure protocol was never triggered.

## Layout audit

Swept every file under `Spoken/`. No violations needed fixing. Everything the grep found is on the
allowed list:

**A1 fixed frames — all decorative, none holding text**
- `DesignSystem/AmbientBackground.swift:60` — the three background orbs.
- `Home/Components/ProgressRow.swift:53` — progress capsule height, 5pt.
- `Onboarding/Components/ProgressPills.swift:23` — the four step pills, 28x6pt.
- `Onboarding/Components/SelectionBadge.swift:13` — the tick circle, and it is `@ScaledMetric`, so
  it grows with Dynamic Type.

**A2 spacing** — one hit, `Home/Components/CardStack.swift:52`, and it is `Space.xxl + Space.m`
multiplied by the stack depth. Derived from the scale, not a raw number. No other file uses a
number for padding or spacing.

**A3 `UIScreen`** — none. One earlier attempt at a screen-width transition was caught during Step 4
and replaced before it was committed.

**A4 `GeometryReader`** — two, both measuring rather than sizing:
- `Home/Components/CardStack.swift:58` reads the deck width so the 35% commit threshold is a share
  of the card, not a hardcoded distance.
- `Home/Components/WordCard.swift:16` reads the card's own bounds so short content centres and long
  content scrolls.

**A5 truncation guards** — three, none of which cut meaning:
- `Home/Components/WordCard.swift:39-40` — `lineLimit(1)` plus `minimumScaleFactor(0.8)` on the
  vocabulary word. A single word has nowhere to wrap; without this it clipped to "hones" on an
  iPhone SE at AX5. The floor is 0.8, the lowest the rules allow.
- `Home/Components/ActionsBar.swift` — the "Speak" label, which is dropped entirely at accessibility
  sizes rather than being shortened. VoiceOver still reads it.

**A6 `ignoresSafeArea`** — only `AmbientBackground.swift:53`, as intended.

**A7 fonts** — every `.font(.system(...))` outside `TypeScale` is an SF Symbol icon size driven by
`@ScaledMetric`. No text bypasses `TypeScale`.

**A8 interest chips** — a custom `FlowLayout` (`DesignSystem/FlowLayout.swift`). A `LazyVGrid` was
tried first and rejected: its columns are all one width, and the design's chips are each as wide as
their own word. The flow layout reflows by real width, so it wraps differently on a 375pt SE than a
420pt Air, which is correct rather than a defect.

## Bugs found and fixed along the way

- `Font.system(size:)` does not scale with Dynamic Type. The whole type scale looked identical at
  AX5 until this was caught; `TypeScale` now runs every size through `@ScaledMetric`.
- Cards behind the top one were readable through it. The card fill is now solid.
- The deck went blank for a quarter second during the fly off. The deck now advances immediately and
  the departing card flies separately above it.
- The progress row read "6 of 5 words". Today's deck is now exactly the daily goal.
- On an iPhone SE at AX5 the card stack painted over the progress row; the deck now reserves the
  space its rear cards rise into.
- The actions bar starved its middle item, truncating "Speak" to "Spe...". The label now takes its
  natural width and the two icons share what is left.

## Known limitations

- **Saved words are in memory only.** The heart fills and clears within a session and is not
  written to storage. No screen in the five reference images lists saved words, and the instruction
  was not to add anything the images do not show.
- **Onboarding screens 2 to 4 were AX5-verified on iPhone Air, not iPhone SE.** Driving the SE
  interactively needed a device-access prompt that could not be answered overnight. Screen 1 and
  Home were verified on the SE headlessly, at both default and AX5.
- **Haptics cannot be felt in a simulator.** The threshold haptic was proved by instrumenting the
  crossing with a temporary visible ring and confirming from a 60fps recording that it fires about
  0.6s before the finger lifts. The probe was removed before committing.

## Totals

16 commits before this one, 17 with it. Every commit is on `origin/main`.
