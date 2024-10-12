//
//  File.swift
//  MarkdownEditor
//
//  Created by Calvin Chestnut on 10/12/24.
//

import Foundation

public struct BoldCommand: MarkdownCommand {
    public let startMarker = "**"
    public let endMarker = "**"
    
    public init() {}
}
