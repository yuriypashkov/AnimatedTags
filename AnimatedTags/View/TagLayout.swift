//
//  TagLayout.swift
//  AnimatedTags
//
//  Created by Yuriy Pashkov on 17.05.2024.
//

import Foundation
import SwiftUI

struct TagLayout: Layout {
    
    typealias LSElements = [LayoutSubviews.Element]
    
    var alignment: Alignment = .center
    
    var spacing: CGFloat = 12
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var height: CGFloat = 0
        let rows = generateRows(maxWidth: maxWidth, proposal: proposal, subviews: subviews)
        
        for (index, row) in rows.enumerated() {
            // find max height for each row and add it to total height
            if index == rows.count - 1 {
                // last item doesn't have spacing
                height += getMaxHeight(elements: row, proposal: proposal)
            } else {
                height += getMaxHeight(elements: row, proposal: proposal) + spacing
            }
        }
        
        return CGSize(width: maxWidth, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        // placing views
        var origin = bounds.origin
        let maxWidth = bounds.width
        let rows = generateRows(maxWidth: maxWidth, proposal: proposal, subviews: subviews)
        
        for row in rows {
            // change origin X based on alignments
            let leading: CGFloat = bounds.maxX - maxWidth
            let trailing: CGFloat = bounds.maxX - (row.reduce(0) { result, view in
                let width = view.sizeThatFits(proposal).width
                if view == row.last {
                    // no spacing
                    return result + width
                } else {
                    // with spacing
                    return result + width + spacing
                }
            })
            let center = (leading + trailing) / 2
            
            // reset origin X for each row
            origin.x = (alignment == .leading ? leading : alignment == .trailing ? trailing : center)
            
            for view in row {
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                // update origin X
                origin.x += (viewSize.width + spacing)
            }
            
            // update origin Y
            origin.y += (getMaxHeight(elements: row, proposal: proposal) + spacing)
        }
        
        
    }
    
    // Make rows based on avalaible size
    private func generateRows(maxWidth: CGFloat, proposal: ProposedViewSize, subviews: Subviews) -> [LSElements] {
        var row: LSElements = []
        var rows: [LSElements] = []
        
        var origin = CGRect.zero.origin
        
        for view in subviews {
            let viewSize = view.sizeThatFits(proposal)
            
            if (viewSize.width + origin.x + spacing) > maxWidth {
                // pushing new row
                rows.append(row)
                row.removeAll()
                // reset origin
                origin.x = 0
                row.append(view)
                // updating origin.x
                origin.x += (viewSize.width + spacing)
            } else {
                // add item to same row
                row.append(view)
                // updating origin.x
                origin.x += (viewSize.width + spacing)
            }
        }
        
        if !row.isEmpty {
            rows.append(row)
            row.removeAll()
        }
        
        return rows
    }
    
    private func getMaxHeight(elements: LSElements, proposal: ProposedViewSize) -> CGFloat {
        return elements.compactMap { view in
            return view.sizeThatFits(proposal).height
        }.max() ?? 0
    }
}


#Preview {
    ContentView()
}
