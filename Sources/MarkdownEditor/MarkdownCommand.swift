//
//  File.swift
//  MarkdownEditor
//
//  Created by Calvin Chestnut on 10/12/24.
//

import Foundation

public protocol MarkdownCommand {
    var startMarker: String { get }
    var endMarker: String { get }

    /// Applies the markdown command to the provided range, adjusting markers as needed.
    func apply(to range: Range<String.Index>, in content: inout String) -> Range<String.Index>

    /// Applies the markdown command to an insertion point, adjusting markers as needed.
    func apply(to insertionPoint: String.Index, in content: inout String) -> Range<String.Index>
}

extension MarkdownCommand {
    public func apply(to range: Range<String.Index>, in content: inout String) -> Range<String.Index> {
        let startLength = startMarker.count
        let endLength = endMarker.count

        var actingLowerLimit = range.lowerBound
        var actingUpperLimit = range.upperBound
        
        if endLength > 0 {
            var removed = false
            if content.count >= endLength + startLength {
                for index in 0...endLength {
                    let actingLower = content.index(actingUpperLimit, offsetBy: -(endLength - index))
                    let distanceToEnd = content.distance(from: actingLower, to: content.endIndex)
                    guard distanceToEnd >= endLength, !removed else { continue }
                    let actingUpper = content.index(actingLower, offsetBy: endLength)
                    
                    if content[actingLower..<actingUpper] == endMarker {
                        actingUpperLimit = actingLower
                        content.removeSubrange(actingLower..<actingUpper)
                        removed = true
                    }
                }
            }
            if !removed {
                content.insert(contentsOf: endMarker, at: actingUpperLimit)
                actingUpperLimit = content.index(actingUpperLimit, offsetBy: endLength)
            }
        }
        if startLength > 0 {
            var removed = false
            if content.count >= endLength + startLength {
                for index in 0...startLength {
                    guard content.distance(from: content.startIndex, to: actingLowerLimit) >= index, !removed else { continue }
                    let actingLower = content.index(actingLowerLimit, offsetBy: -index)
                    guard content.distance(from: actingLower, to: content.endIndex) >= startLength else { continue }
                    let actingUpper = content.index(actingLower, offsetBy: startLength)
                    
                    if content[actingLower..<actingUpper] == startMarker {
                        actingLowerLimit = actingLower
                        actingUpperLimit = content.index(actingUpperLimit, offsetBy: -startLength)
                        content.removeSubrange(actingLower..<actingUpper)
                        removed = true
                    }
                }
            }
            if !removed {
                content.insert(contentsOf: startMarker, at: actingLowerLimit)
                actingUpperLimit = content.index(actingUpperLimit, offsetBy: startLength)
            }
        }

        return actingLowerLimit..<actingUpperLimit
    }

    public func apply(to insertionPoint: String.Index, in content: inout String) -> Range<String.Index> {
        let startLength = startMarker.count
        let endLength = endMarker.count
        var newInsertion = insertionPoint
        var removed = false

        // Check if we're inside a n existing marker (e.g., "****")
        if content.count >= startLength + endLength {
            if content.distance(from: content.startIndex, to: insertionPoint) >= startLength && content.distance(from: insertionPoint, to: content.endIndex) >= endLength {
                let startCheck = content.index(insertionPoint, offsetBy: -startLength)
                let endCheck = content.index(insertionPoint, offsetBy: startLength)

                if content[startCheck..<insertionPoint] == startMarker, content[insertionPoint..<endCheck] == endMarker {
                    // Remove surrounding markers
                    content.removeSubrange(insertionPoint..<endCheck)
                    content.removeSubrange(startCheck..<insertionPoint)
                    newInsertion = startCheck
                    removed = true
                }
            }
        }
        if !removed {
            // Apply markers
            content.insert(contentsOf: startMarker, at: insertionPoint)
            content.insert(contentsOf: endMarker, at: content.index(insertionPoint, offsetBy: startLength))
            // Return the insertion point after the start marker
            newInsertion = content.index(insertionPoint, offsetBy: startLength)
        }
        return newInsertion..<newInsertion
    }
}
