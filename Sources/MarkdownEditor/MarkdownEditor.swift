//
//  File.swift
//  MarkdownEditor
//
//  Created by Calvin Chestnut on 10/12/24.
//

import SwiftUI

@available(iOS 18.0, *)
public struct MarkdownEditor<T: View>: View {
    @Binding var text: String
    @Binding var selection: TextSelection?
    
    @ViewBuilder
    let toolbarBuilder: (() -> T)?
    
    let selectionHandler: SelectionHandler = .init()
    
    @State
    private var showFormatting: Bool = false

    public init(text: Binding<String>, selection: Binding<TextSelection?>, toolbarBuilder: (() -> T)? = nil) {
        self._text = text
        self._selection = selection
        self.toolbarBuilder = toolbarBuilder
        self.selection = .init(insertionPoint: text.wrappedValue.startIndex)
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
                apply(command: BoldCommand())
            }, toggleItalic: {
                apply(command: ItalicCommand())
            }, toggleStrike: {
                apply(command: StrikeCommand())
            })
            .popover(isPresented: $showFormatting, attachmentAnchor: .point(.topLeading)) {
//                FormattingSheet(string: $text, selection: $selection)
//                    .presentationCompactAdaptation(.popover)
            }
        }
    }
    
    func apply(command: MarkdownCommand) {
        let nextSelection = SelectionHandler.handleSelection(command: command, text: &text, selection: selection)
        selection = nextSelection
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
// Add back when ready for Headings
//        Button(action: toggleSheet, label: {
//            Label {
//                Text("formatting")
//            } icon: {
//                Image(systemName: "textformat")
//            }
//        })
        Button(action: toggleBold, label: {
            Label {
                Text("bold")
            } icon: {
                Image(systemName: "bold")
            }
        })
        .foregroundStyle(Color.primary)
        Button(action: toggleItalic, label: {
            Label {
                Text("italic")
            } icon: {
                Image(systemName: "italic")
            }
        })
        .foregroundStyle(Color.primary)
        Button(action: toggleStrike, label: {
            Label {
                Text("strike")
            } icon: {
                Image(systemName: "strikethrough")
            }
        })
        .foregroundStyle(Color.primary)
    }
}

@available(iOS 18.0, *)
#Preview {
    @Previewable @State
    var string: String = ""
    @Previewable @State
    var selection: TextSelection?
    MarkdownEditor<StandardToolbar>(text: $string, selection: $selection)
}

