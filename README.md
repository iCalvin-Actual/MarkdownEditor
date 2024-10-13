#  MarkdownEditor for SwiftUI

### known bugs

- Sometimes the Range returned from an apply action will wrap to the next line unexpectedly

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



