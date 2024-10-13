//
//  File.swift
//  MarkdownEditor
//
//  Created by Calvin Chestnut on 10/12/24.
//

import Foundation

public struct BoldCommand: MarkdownCommand {
    public let startMarker = "*"
    public let endMarker = "*"
    
    public init() {}
}
public struct StrongCommand: MarkdownCommand {
    public let startMarker = "**"
    public let endMarker = "**"
    
    public init() {}
}

public struct ItalicCommand: MarkdownCommand {
    public let startMarker = "_"
    public let endMarker = "_"
    
    public init() {}
}

public struct StrikeCommand: MarkdownCommand {
    public let startMarker = "~"
    public let endMarker = "~"
    
    public init() {}
}
