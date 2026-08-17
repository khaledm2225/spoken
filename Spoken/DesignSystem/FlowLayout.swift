import SwiftUI

/// Lays views out left to right and wraps to a new line when the next one will
/// not fit, the way words wrap in a paragraph.
///
/// A `LazyVGrid` was the obvious reach here, but its columns are all one width,
/// and the design's chips are each as wide as their own word. This keeps every
/// chip its natural size. Rows are worked out from the width actually offered
/// and the sizes the chips report, so nothing is hard coded: the same code
/// reflows for a longer word, a wider phone or an accessibility type size.
struct FlowLayout: Layout {
    var horizontalSpacing: CGFloat = Space.xs
    var verticalSpacing: CGFloat = Space.m

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let width = proposal.replacingUnspecifiedDimensions().width
        let rows = rows(fitting: width, subviews: subviews)
        let height = rows.map(\.height).reduce(0, +)
            + verticalSpacing * CGFloat(max(0, rows.count - 1))
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        var y = bounds.minY
        for row in rows(fitting: bounds.width, subviews: subviews) {
            var x = bounds.minX
            for index in row.indices {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(
                    at: CGPoint(x: x, y: y + (row.height - size.height) / 2),
                    proposal: ProposedViewSize(size)
                )
                x += size.width + horizontalSpacing
            }
            y += row.height + verticalSpacing
        }
    }

    private struct Row {
        var indices: [Int] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private func rows(fitting width: CGFloat, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        var row = Row()

        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let spacing = row.indices.isEmpty ? 0 : horizontalSpacing

            // A chip wider than the line still gets its own row rather than
            // being squeezed, so its text never has to shrink or truncate.
            if !row.indices.isEmpty, row.width + spacing + size.width > width {
                rows.append(row)
                row = Row()
            }

            row.indices.append(index)
            row.width += (row.indices.count == 1 ? 0 : horizontalSpacing) + size.width
            row.height = max(row.height, size.height)
        }

        if !row.indices.isEmpty { rows.append(row) }
        return rows
    }
}
