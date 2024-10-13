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

@Test func applyBoldBlockInsertionPoinotText() async throws {
    let targetString = "targetString"
    let resultString = "****\(targetString)"
    var largerText: String = """
    # some text

    \(targetString)

    moreText
    """
    guard let targetRange = largerText.firstRange(of: targetString) else { return }
    let targetIndex = targetRange.lowerBound
    let rangeBeta = BoldCommand().apply(to: targetIndex, in: &largerText)
    guard let found = largerText.firstRange(of: resultString) else { return }
    #expect(largerText.index(found.lowerBound, offsetBy: 2) == rangeBeta.upperBound)
    #expect(rangeBeta.upperBound == rangeBeta.lowerBound)
}

@Test func applyBoldBlockInsertionPointText() async throws {
    let targetString = "targetString"
    let resultString = "**\(targetString)**"
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

@Test func applyBoldBlockText() async throws {
    let targetString = "targetString"
    let resultString = "**\(targetString)**"
    var largerText: String = """
    # some text

    \(targetString)

    moreText
    """
    guard let targetRange = largerText.firstRange(of: targetString) else { return }
    let rangeBeta = BoldCommand().apply(to: targetRange.lowerBound..<targetRange.upperBound, in: &largerText)
    guard let found = largerText.firstRange(of: resultString) else { return }
    print("Success")
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

@Test func extremeTest() async throws {
    let testString = "{profile-picture}\r\n\r\n# Calvin\r\n\r\n| Pronouns: He/They\r\n| Gender: Non-Binary {venus-mars}\r\n| Occupation: Engineer\r\n| Location: Salem, MA\r\n\r\n---\r\n\r\n--- Bio ---\r\n\r\nWitchy person about town. I’m a Scorpio, sorry if that’s a red flag.\r\n\r\n[What am I doing /now?](/now)\r\n\r\n\r\n--- Contact ---\r\n\r\n#### Stuff I Make\r\n\r\n- [app.lol @ App Store](https://app.url.lol/gimme)\r\n- [Photos @ Glass](https://glass.photo/calvin-chestnut)\r\n- [Videos @ TikTok](https://www.tiktok.com/@calvin_ccb)\r\n- [Selfies @ Snap](https://t.snapchat.com/gso7jT8h)\r\n\r\n\r\n--- Hobbies ---\r\n\r\n#### Hobbies\r\n\r\n- Photography {camera}\r\n- Skateboarding {heart-pulse}\r\n- App Development {mobile}\r\n- Dungeons & Dragons {dice}\r\n- So Much Cannabis {cannabis}"
    var stringA = testString
    var stringB = testString
    guard let scorpioRange = testString.range(of: "Scorpio") else {
        return
    }
    let resultA = BoldCommand().apply(to: scorpioRange.lowerBound, in: &stringA)
    let resultB = BoldCommand().apply(to: scorpioRange, in: &stringB)
    print("Check")
}
