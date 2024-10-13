import Testing
@testable import MarkdownEditor

@Test func testApplyBoldEmptyString() async throws {
    var emptyText: String = ""
    let insertion = BoldCommand().apply(to: emptyText.startIndex, in: &emptyText)
    #expect(emptyText == "****")
    #expect(insertion.lowerBound == emptyText.index(emptyText.startIndex, offsetBy: 2))
    #expect(insertion.lowerBound == insertion.upperBound)
}

@Test func textApplyBoldEmptyBoldString() async throws {
    var boldedInsertion: String = "****"
    let insertion = BoldCommand().apply(to: boldedInsertion.index(boldedInsertion.startIndex, offsetBy: 2), in: &boldedInsertion)
    #expect(insertion.lowerBound == boldedInsertion.startIndex)
    #expect(insertion.lowerBound == insertion.upperBound)
    #expect(boldedInsertion == "")
}

@Test func testApplyBoldRegularText() async throws {
    var valueText: String = "Hello, World!"
    
    let rangeAlpha = BoldCommand().apply(to: valueText.startIndex..<valueText.endIndex, in: &valueText)
    #expect(rangeAlpha.lowerBound == valueText.startIndex)
    #expect(rangeAlpha.upperBound == valueText.endIndex)
    #expect(valueText == "**Hello, World!**")
}

@Test func testApplyBoldBoldedText() async throws {
    for i in 0...2 {
        var targetText: String = "Hello, World!"
        var boldedText: String = "**\(targetText)**"
        let rangeBeta = BoldCommand().apply(to: boldedText.index(boldedText.startIndex, offsetBy: i)..<boldedText.index(boldedText.endIndex, offsetBy: -i), in: &boldedText)
        if i < 2 {
            #expect(rangeBeta.lowerBound == boldedText.startIndex)
            #expect(rangeBeta.upperBound == boldedText.endIndex)
            #expect(boldedText == targetText)
        } else {
            #expect(rangeBeta.lowerBound != boldedText.startIndex)
            #expect(rangeBeta.upperBound != boldedText.endIndex)
            #expect(boldedText.hasPrefix("**"))
            #expect(boldedText.hasSuffix("**"))
            #expect(!boldedText.contains(targetText))
        }
    }
}

@Test func applyBoldBlockText() async throws {
    var largerText: String = """
# some text

targetString

moreText
"""
    guard let range = largerText.range(of: "targetString") else {
        return
    }
    let resultRange = BoldCommand().apply(to: range, in: &largerText)
}

@Test func applyBoldBlockPartiallyBoldedText() async throws {
    var largerBold: String = """
# some text

**targetString**

moreText
"""
    guard let range = largerBold.range(of: "targetString") else {
        return
    }
    let resultRange = BoldCommand().apply(to: range, in: &largerBold)
}
