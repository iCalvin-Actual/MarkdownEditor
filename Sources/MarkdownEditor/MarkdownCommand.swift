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
    func apply(to insertionPoint: String.Index, in content: inout String) -> String.Index
}

extension MarkdownCommand {
    public func apply(to range: Range<String.Index>, in content: inout String) -> Range<String.Index> {
        let startLength = startMarker.count
        let endLength = endMarker.count

        var actingLowerLimit = range.lowerBound
        var actingUpperLimit = range.upperBound

        // 1. Check if the suffix exists and remove or add it first
        if content.distance(from: range.upperBound, to: content.endIndex) >= endLength {
            let endSuffixRange = range.upperBound..<content.index(range.upperBound, offsetBy: endLength)
            if content[endSuffixRange] == endMarker {
                // Remove suffix if already present
                content.removeSubrange(endSuffixRange)
                actingUpperLimit = content.index(actingUpperLimit, offsetBy: -endLength)
            } else {
                // Add suffix
                content.insert(contentsOf: endMarker, at: actingUpperLimit)
            }
        }

        // 2. Check if the prefix exists and remove or add it
        if content.distance(from: content.startIndex, to: range.lowerBound) >= startLength {
            let startPrefixRange = content.index(range.lowerBound, offsetBy: -startLength)..<range.lowerBound
            if content[startPrefixRange] == startMarker {
                // Remove prefix if already present
                content.removeSubrange(startPrefixRange)
                actingLowerLimit = content.index(actingLowerLimit, offsetBy: -startLength)
                actingUpperLimit = content.index(actingUpperLimit, offsetBy: -startLength) // Adjust upper bound
            } else {
                // Add prefix
                content.insert(contentsOf: startMarker, at: actingLowerLimit)
                actingUpperLimit = content.index(actingUpperLimit, offsetBy: startLength) // Adjust upper bound
            }
        }

        // 3. Return the new range, including the markers
        return actingLowerLimit..<actingUpperLimit
    }

    public func apply(to insertionPoint: String.Index, in content: inout String) -> String.Index {
        let startLength = startMarker.count
        let endLength = endMarker.count

        // Check if we're inside an existing marker (e.g., "****")
        let startCheck = content.index(insertionPoint, offsetBy: -min(startLength, content.distance(from: content.startIndex, to: insertionPoint)))
        let endCheck = content.index(insertionPoint, offsetBy: min(endLength, content.distance(from: insertionPoint, to: content.endIndex)))

        if content[startCheck..<insertionPoint] == startMarker, content[insertionPoint..<endCheck] == endMarker {
            // Remove surrounding markers
            content.removeSubrange(startCheck..<insertionPoint)
            content.removeSubrange(insertionPoint..<endCheck)
            return startCheck
        } else {
            // Apply markers
            content.insert(contentsOf: startMarker, at: insertionPoint)
            content.insert(contentsOf: endMarker, at: content.index(insertionPoint, offsetBy: startLength))
            // Return the insertion point after the start marker
            return content.index(insertionPoint, offsetBy: startLength)
        }
    }
}
