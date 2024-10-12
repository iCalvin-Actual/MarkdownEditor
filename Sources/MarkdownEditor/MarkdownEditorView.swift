//
//  File.swift
//  MarkdownEditor
//
//  Created by Calvin Chestnut on 10/12/24.
//

import SwiftUI

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
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button {
                        let newContent = selectionHandler.handleSelection(command: BoldCommand(), text: &text, selection: selection)
                        print(newContent)
                    } label: {
                        Label(
                            title: { Text("bold") },
                            icon: { Image(systemName: "bold") }
                        )
                    }

                }
            }
            .background(Color.red)
    }
}

#Preview {
    @Previewable @State
    var string: String = ""
    @Previewable @State
    var selection: TextSelection?
    MarkdownEditorView(text: $string, selection: $selection)
}

