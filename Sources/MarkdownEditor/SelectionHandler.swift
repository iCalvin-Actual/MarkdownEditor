//
//  File.swift
//  MarkdownEditor
//
//  Created by Calvin Chestnut on 10/12/24.
//

import SwiftUI

public struct SelectionHandler {
    /// Handles applying a markdown command to a selection or insertion point.
    ///
    /// - Parameters:
    ///   - command: The `MarkdownCommand` to apply (e.g., bold, italic).
    ///   - text: The full text content in the editor.
    ///   - selection: The `TextSelection?` representing either a text range or insertion point.
    ///
    /// - Returns: The new `TextSelection` reflecting changes after applying the command.
    public func handleSelection(command: some MarkdownCommand, text: inout String, selection: TextSelection?) -> TextSelection? {
        guard let selection else { return nil }

        switch selection.indices {
        case .selection(let range):
            if selection.isInsertion {
                let newInsertionPoint = command.apply(to: range.lowerBound, in: &text)
                return TextSelection(range: .init(uncheckedBounds: (lower: newInsertionPoint, upper: newInsertionPoint)))
            }
            let newRange = command.apply(to: range, in: &text)
            return TextSelection(range: newRange)

        case .multiSelection(let ranges):
            var newRanges: RangeSet<String.Index> = .init()
            ranges.ranges.sorted(by: { $0.upperBound > $1.lowerBound }).forEach { range in
                if selection.isInsertion {
                    let newInsertion = command.apply(to: range.lowerBound, in: &text)
                    newRanges.insert(contentsOf: Range(uncheckedBounds: (lower: newInsertion, upper: newInsertion)))
                } else {
                    newRanges.insert(contentsOf: command.apply(to: range, in: &text))
                }
            }
            return TextSelection(ranges: newRanges)

        @unknown default:
            return nil
        }
    }
}
