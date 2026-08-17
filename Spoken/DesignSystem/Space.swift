import SwiftUI

/// The only spacing values in the app. Every padding and stack spacing comes
/// from here, so a raw number in a view is a visible mistake.
enum Space {
    static let xs: CGFloat = 8
    static let s: CGFloat = 12
    static let m: CGFloat = 16
    static let l: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}
