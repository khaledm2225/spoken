import SwiftUI

/// The one call to action in the app. Height comes from padding plus the label,
/// so it grows with Dynamic Type instead of clipping.
struct PrimaryButton: View {
    let title: String
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .uiText(17, .semibold)
                .foregroundStyle(Palette.ctaLabel)
                .padding(.vertical, Space.m)
                .frame(maxWidth: .infinity)
                .background(Palette.accent.opacity(isEnabled ? 1 : 0.35), in: Capsule())
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    ZStack {
        AmbientBackground()
        VStack(spacing: Space.m) {
            PrimaryButton(title: "Continue") {}
            PrimaryButton(title: "Continue", isEnabled: false) {}
        }
        .padding(Space.l)
    }
}
