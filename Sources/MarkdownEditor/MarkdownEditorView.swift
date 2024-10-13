//
//  File.swift
//  MarkdownEditor
//
//  Created by Calvin Chestnut on 10/12/24.
//

import SwiftUI

@available(iOS 18.0, *)
public struct MarkdownEditorView<C: View>: View {
    @Binding var text: String
    @Binding var selection: TextSelection?
    
    @ViewBuilder
    let toolbarBuilder: (() -> C)?
    
    let selectionHandler: SelectionHandler = .init()
    
    @State
    private var showFormatting: Bool = false

    public init(text: Binding<String>, selection: Binding<TextSelection?>, toolbarBuilder: (() -> C)? = nil) {
        self._text = text
        self._selection = selection
        self.toolbarBuilder = toolbarBuilder
    }

    public var body: some View {
        TextEditor(text: $text, selection: $selection)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    appropriateToolbar
                        .popover(isPresented: $showFormatting, attachmentAnchor: .point(.topLeading)) {
                            FormattingSheet(string: $text, selection: $selection)
                                .presentationCompactAdaptation(.popover)
                        }
                }
            }
    }
    
    @ViewBuilder
    private var appropriateToolbar: some View {
        if let toolbarBuilder {
            toolbarBuilder()
        } else {
            StandardToolber(action: {
                withAnimation {
                    showFormatting.toggle()
                }
            })
        }
    }
}

@available(iOS 18.0, *)
struct StandardToolber: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Label {
                Text("formatting")
            } icon: {
                Image(systemName: "textformat")
            }
        })
    }
}

@available(iOS 18.0, *)
#Preview {
    @Previewable @State
    var string: String = ""
    @Previewable @State
    var selection: TextSelection?
    MarkdownEditorView<StandardToolber>(text: $string, selection: $selection)
}

