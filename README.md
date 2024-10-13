#  MarkdownEditor for SwiftUI

## the goal

A simple markdown editor that shows tags instead of rendered markdown, and allows for quick toggling of common markdown tags rather than only typing values out.

## Components

There are two main access points for the library

### MarkdownCommand

A simple protocol that will wrap Markdown tags around a string with the `.apply(to: range, in: string)` function. Alternatively, if the markdown tag already exists, the Command will strip the tags away.

`apply(to:, in:)` accepts either a range or a single insertion point, and will return a range which represents the new insertion point after modifying the text. 

Before inserting the markdown tags, however, first `apply` checks to see if the tags exist, either within the given target range or outside it, checking the length of the start/end tag text if necessary.

Usage
```
var text: String = "some pig"
guard let range = text.firstRange(of: "some") else { return }
let newRange = ItalicCommand().apply(to: range, in: &text)
print(text)     // prints "_some_ pig"
print(newRange) // prints "some" 
```

### MarkdownEditor

A drop-in replacement for `SwiftUI.TextEditor` that enables quick markdown formatting. It includes a default Keyboard Toolbar with buttons to toggle common Markdown tags, but you can pass in a custom View to use instead.

Basic usage
```
import MarkdownEditor

struct myView: View {
  @State var text: String
  @State var textSelection: TextSelection?

  var body: some View {
    MarkdownEditor<StandardToolbar>(text: $text, selection: $selection)
  }
} 
```

Custom toolbar

```
...
@State 
var showFormattingSheet: Bool

var body: some View {
  MarkdownEditor(text: $text, selection: $selection) {
    Button(action: {
      showFormattingSheet.toggle()
    }, label: {
      Label {
        Text("formatting")
      } icon: {
        Image(systemName: "textformat")
      }
    }
    .popover(isPresented: $showFormattingSheet, attachmentAnchor: .point(.topLeading)) {
        FormattingSheet(string: $text, selection: $selection)
            .presentationCompactAdaptation(.popover)
    }
})
  }
}
```

### known bugs

- Sometimes the Range returned from an apply action will wrap to the next line unexpectedly

- Apply shouldn't include the markdown tags in the returned text range

### todo

- Validate support on other Platforms (macOS, visionOS, watchOS, tvOS)

- Update paragraph handling

Where the current methodology will handle a multi-paragraph selection like such
```
some paragraph **text

more text to highlight

ending** paragraph
``` 
Update the selection to return individual selection ranges for each new line, such that the result of `apply()` matches the following
```
some paragraph **text**

**more text to highlight**

**ending** paragraph
```

- Add Paragraph modifier commands

Move the acting upper+lower bounds to the start/end of the current line before evaluating the command

- Paragraph toggle button

Context menu to select between paragraph, Title, title2, title3, title4, title5, title6, and list styles

- Build out a Standard formatter sheet to simplify toolbar options

- Add Code (inline and paragraph) Commands



