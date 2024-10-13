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
                }
            }
    }
    
    @ViewBuilder
    private var appropriateToolbar: some View {
        if let toolbarBuilder {
            toolbarBuilder()
        } else {
            StandardToolbar(toggleSheet: {
                withAnimation {
                    showFormatting.toggle()
                }
            }, toggleBold: {
                let nextSelection = SelectionHandler.handleSelection(command: BoldCommand(), text: &text, selection: selection)
                selection = nextSelection
            })
            .popover(isPresented: $showFormatting, attachmentAnchor: .point(.topLeading)) {
                FormattingSheet(string: $text, selection: $selection)
                    .presentationCompactAdaptation(.popover)
            }
        }
    }
}

@available(iOS 18.0, *)
public struct StandardToolbar: View {
    let toggleSheet: () -> Void
    let toggleBold: () -> Void
    let toggleItalic: () -> Void
    let toggleStrike: () -> Void
    
    init(toggleSheet: @escaping () -> Void = { }, toggleBold: @escaping () -> Void = { }, toggleItalic: @escaping () -> Void = { }, toggleStrike: @escaping () -> Void = { }) {
        self.toggleSheet = toggleSheet
        self.toggleBold = toggleBold
        self.toggleItalic = toggleItalic
        self.toggleStrike = toggleStrike
    }
    
    public var body: some View {
        Button(action: toggleSheet, label: {
            Label {
                Text("formatting")
            } icon: {
                Image(systemName: "textformat")
            }
        })
        Button(action: toggleBold, label: {
            Label {
                Text("bold")
            } icon: {
                Image(systemName: "bold")
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
    MarkdownEditorView<StandardToolbar>(text: $string, selection: $selection)
}

