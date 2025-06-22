//
//  File.swift
//  MarkdownEditor
//
//  Created by Calvin Chestnut on 10/12/24.
//

import SwiftUI

@available(iOS 18.0, macOS 15.0, *)
public struct SelectionHandler {
    /// Handles applying a markdown command to a selection or insertion point.
    ///
    /// - Parameters:
    ///   - command: The `MarkdownCommand` to apply (e.g., bold, italic).
    ///   - text: The full text content in the editor.
    ///   - selection: The `TextSelection?` representing either a text range or insertion point.
    ///
    /// - Returns: The new `TextSelection` reflecting changes after applying the command.
    public static func handleSelection(command: some MarkdownCommand, text: inout String, selection: TextSelection?) -> TextSelection? {
        guard let selection else { return nil }

        switch selection.indices {
        case .selection(let range):
            if selection.isInsertion {
                let newInsertionPoint = command.apply(to: range.lowerBound, in: &text)
                return TextSelection(range: newInsertionPoint)
            }
            let rangeString = text[range]
            let splitRanges: [Substring] = rangeString.split(whereSeparator: \.isNewline).reduce([Substring]()) { partialResult, nextItem in
                guard nextItem.count > 0 else {
                    return partialResult
                }
                return partialResult + [nextItem]
            }
            var actingInsertionPoint = range.lowerBound
            let newRanges: RangeSet<String.Index> = splitRanges.enumerated().reduce(.init()) { partialResult, item in
                let subString = item.element
                let startIndex = actingInsertionPoint
                if let newRange = text.range(of: subString, range: startIndex..<range.upperBound) {
                    let nextIndex = splitRanges.index(after: item.offset)
                    
                    if item.offset < splitRanges.index(splitRanges.endIndex, offsetBy: -1) {
                        let nextItem = splitRanges[nextIndex]
                        let nextRange = text.range(of: nextItem, range: newRange.upperBound..<text.endIndex)
                        actingInsertionPoint = nextRange?.lowerBound ?? newRange.upperBound
                    }
                    return partialResult.union(RangeSet(newRange))
                }
                return partialResult
            }
            var actingOffset: Int = 0
            let sortedRanges: [Range<String.Index>] = newRanges.ranges
            .map { range in
                let newLength = text.distance(from: range.lowerBound, to: range.upperBound)
                let newLower = text.index(range.lowerBound, offsetBy: actingOffset)
                var newUpper = text.index(newLower, offsetBy: newLength)
                if newUpper > text.endIndex {
                    newUpper = text.endIndex
                }
                let newRange = newLower..<newUpper
                actingOffset += command.endMarker.count + command.startMarker.count
                let result = command.apply(to: newRange, in: &text)
                return result
            }
            let returnSelection = TextSelection(ranges: RangeSet(sortedRanges))
            return returnSelection

        case .multiSelection(let ranges):
            let newRanges = ranges.ranges
                .sorted(by: { $0.upperBound > $1.lowerBound })
                .reduce(RangeSet<String.Index>(), { partialResult, selection in
                    let rangeString = text[selection]
                    var actingInsertionPoint = selection.lowerBound
                    let splitRanges: [Substring] = rangeString.split(whereSeparator: \.isNewline).reduce([Substring]()) { partialResult, nextItem in
                        guard nextItem.count > 0 else {
                            return partialResult
                        }
                        return partialResult + [nextItem]
                    }
                    let newRanges: RangeSet<String.Index> = splitRanges.reduce(.init()) { innerResult, subString in
                        let startIndex = actingInsertionPoint
                        if let newRange = text.range(of: subString, range: startIndex..<selection.upperBound) {
                            actingInsertionPoint = newRange.upperBound
                            return innerResult.union(RangeSet(newRange))
                        }
                        return innerResult
                    }
                    return partialResult.union(newRanges)
                })
                .ranges.map { command.apply(to: $0, in: &text) }
            return TextSelection(ranges: RangeSet(newRanges))

        @unknown default:
            return nil
        }
    }
}
