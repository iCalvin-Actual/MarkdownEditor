//
//  SwiftUIView.swift
//  MarkdownEditor
//
//  Created by Calvin Chestnut on 10/13/24.
//

import SwiftUI

@available(iOS 18.0, *)
public struct FormattingSheet: View {
    @Environment(\.dismiss)
    var dismiss
    
    @Binding
    var string: String
    @Binding
    var selection: TextSelection?
    
    public var body: some View {
        VStack {
            HStack {
                Button {
                    let nextSelection = SelectionHandler.handleSelection(command: BoldCommand(), text: &string, selection: selection)
                    selection = nextSelection
                } label: {
                    Label {
                        Text("bold")
                    } icon: {
                        Image(systemName: "bold")
                    }
                }
                Button {
                    let nextSelection = SelectionHandler.handleSelection(command: ItalicCommand(), text: &string, selection: selection)
                    selection = nextSelection
                } label: {
                    Label {
                        Text("italic")
                    } icon: {
                        Image(systemName: "italic")
                    }
                }
                Button {
                    let nextSelection = SelectionHandler.handleSelection(command: StrikeCommand(), text: &string, selection: selection)
                    selection = nextSelection
                } label: {
                    Label {
                        Text("strikethrough")
                    } icon: {
                        Image(systemName: "strikethrough")
                    }
                }
            }
        }
    }
}

@available(iOS 18.0, *)
#Preview {
    @Previewable @State var string = ""
    @Previewable @State var selection: TextSelection?
    FormattingSheet(string: $string, selection: $selection)
}
