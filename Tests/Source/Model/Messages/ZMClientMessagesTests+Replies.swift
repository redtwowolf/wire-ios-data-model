//
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import XCTest
@testable import WireDataModel

class ZMClientMessagesTests_Replies: BaseZMClientMessageTests {
    
    func createMessage(text: String, quote: ZMClientMessage?) -> ZMClientMessage {
        let zmText = ZMText.text(with: text, mentions: [], linkPreviews: [], quote: quote)
        let message = ZMClientMessage(nonce: UUID(), managedObjectContext: uiMOC)
        message.add(ZMGenericMessage.message(content: zmText).data())
        quote?.replies?.insert(message)
        return message
    }
    
    func testQuoteIsReturned() {
        let quotedMessage = createMessage(text: "I have a proposal", quote: nil)
        let message = createMessage(text: "That's fine", quote: quotedMessage)
        
        XCTAssertEqual(message.quote, quotedMessage)
        XCTAssertTrue(quotedMessage.replies?.contains(message) ?? false)
    }
    
    /*
    func testMentionsAreReturned() {
        // given
        let text = "@john hello"
        let mention = Mention(range: NSRange(location: 0, length: 5), user: user1)
        let message = createMessage(text: text, mentions: [mention])
        
        // when
        let mentions = message.mentions
        
        // then
        XCTAssertEqual(mentions, [mention])
    }
    
    func testMentionsWithMultiplePartCharactersAreReturned() {
        // given
        let text = "@🙅‍♂️"
        let mention = Mention(range: NSRange(location: 0, length: 6), user: user1)
        
        let message = createMessage(text: text, mentions: [mention])
        
        // when
        let mentions = message.mentions
        
        // then
        XCTAssertEqual(mentions, [mention])
    }
    
    func testMentionsWithOverlappingRangesAreDiscarded() {
        // given
        let text = "@john hello"
        let mention = Mention(range: NSRange(location: 0, length: 5), user: user1)
        let mentionOverlapping = Mention(range: NSRange(location: 4, length: 5), user: user2)
        
        let message = createMessage(text: text, mentions: [mention, mentionOverlapping])
        
        // when
        let mentions = message.mentions
        
        // then
        XCTAssertEqual(mentions, [mention])
    }
    
    func testMentionsWithRangesOutsideTextAreDiscarded() {
        // given
        let text = "@john hello"
        let mention = Mention(range: NSRange(location: 0, length: 5), user: user1)
        let mentionOutsideText = Mention(range: NSRange(location: 6, length: 10), user: user2)
        
        let message = createMessage(text: text, mentions: [mention, mentionOutsideText])
        
        // when
        let mentions = message.mentions
        
        // then
        XCTAssertEqual(mentions, [mention])
    }
    
    func testMentionsIsCapppedAt500() {
        // given
        let text = String(repeating: "@", count: 501)
        let tooManyMentions = (0...500).map({ index in
            return Mention(range: NSRange(location: index, length: 1), user: user1)
        })
        let message = createMessage(text: text, mentions: tooManyMentions)
        
        // when
        let mentions = message.mentions
        
        // then
        XCTAssertEqual(mentions.count, 500)
        XCTAssertEqual(mentions, mentions)
        XCTAssertEqual(mentions, Array(tooManyMentions.prefix(500)))
    }*/
    
}
