import Foundation
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
    let targetText: String = "Hello, World!"
    let testCount = Int(floor(Double(targetText.count) / 2))
    for i in 0..<testCount {
        var boldedText: String = "**\(targetText)**"
        let rangeBeta = BoldCommand().apply(to: boldedText.index(boldedText.startIndex, offsetBy: i)..<boldedText.index(boldedText.endIndex, offsetBy: -i), in: &boldedText)
        if i <= 2 {
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
        print(boldedText)
    }
}

@Test func applyBoldBlockText() async throws {
    let targetString = "targetString"
    let resultString = "**\(targetString)**"
    let testCount = BoldCommand().startMarker.count * 2
    var largerText: String = """
    # some text

    \(targetString)

    moreText
    """
    guard let targetRange = largerText.firstRange(of: targetString) else { return }
    let rangeBeta = BoldCommand().apply(to: targetRange.lowerBound..<targetRange.upperBound, in: &largerText)
    guard let found = largerText.firstRange(of: resultString) else { return }
    #expect(rangeBeta.lowerBound == found.lowerBound)
    #expect(rangeBeta.upperBound == found.upperBound)
}

@Test func applyBoldBlockPartiallyBoldText() async throws {
    let targetString = "targetString"
    let resultString = "**\(targetString)**"
    let testCount = Int(floor(Double(targetString.count) / 2))
    for i in 0..<testCount {
        var largerText: String = """
        # some text
        
        \(resultString)
        
        moreText
        """
        guard let targetRange = largerText.firstRange(of: targetString) else { continue }
        let rangeBeta = BoldCommand().apply(to: largerText.index(targetRange.lowerBound, offsetBy: i)..<largerText.index(targetRange.upperBound, offsetBy: -i), in: &largerText)
        if i <= 2 {
            guard let found = largerText.firstRange(of: targetString) else { return }
            #expect(rangeBeta.lowerBound == found.lowerBound)
            #expect(rangeBeta.upperBound == found.upperBound)
            #expect(!largerText.contains(resultString))
        } else {
            #expect(rangeBeta.lowerBound != largerText.startIndex)
            #expect(rangeBeta.upperBound != largerText.endIndex)
            #expect(largerText[rangeBeta].hasPrefix("**"))
            #expect(largerText[rangeBeta].hasSuffix("**"))
            #expect(!largerText.contains(targetString))
        }
        print(largerText)
    }
}
