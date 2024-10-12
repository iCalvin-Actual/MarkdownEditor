//
//  File.swift
//  MarkdownEditor
//
//  Created by Calvin Chestnut on 10/12/24.
//

import SwiftUI

@available(iOS 18.0, *)
public struct MarkdownEditorView: View {
    @Binding var text: String
    @Binding var selection: TextSelection?
    
    let selectionHandler: SelectionHandler = .init()

    public init(text: Binding<String>, selection: Binding<TextSelection?>) {
        self._text = text
        self._selection = selection
    }

    public var body: some View {
        TextEditor(text: $text, selection: $selection)
    }
}

@available(iOS 18.0, *)
#Preview {
    @Previewable @State
    var string: String = ""
    @Previewable @State
    var selection: TextSelection?
    MarkdownEditorView(text: $string, selection: $selection)
}

