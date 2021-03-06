//
// Wire
// Copyright (C) 2018 Wire Swiss GmbH
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

import Foundation

/// This object holds information about a message draft that has not yet been sent
/// by the user but was put into the input field.
@objcMembers public final class DraftMessage: NSObject {

    /// The text of the message.
    public let text: String
    /// The mentiones contained in the text.
    public let mentions: [Mention]
    
    public init(text: String, mentions: [Mention]) {
        self.text = text
        self.mentions = mentions
        super.init()
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? DraftMessage else { return false }
        return (text, mentions) == (other.text, other.mentions)
    }

}

/// A serializable version of `DraftMessage` that conforms to `Codable` and
/// holds on to a `StorableMention` values instead `Mention`.
fileprivate final class StorableDraftMessage: NSObject, Codable {

    /// The text of the message to be stored.
    let text: String
    /// The mentiones contained in the text.
    let mentions: [StorableMention]
    
    init(text: String, mentions: [StorableMention]) {
        self.text = text
        self.mentions = mentions
        super.init()
    }
    
    /// Converts this storable version into a regular `DraftMessage`.
    /// The passed in `context` is needed to fetch the user objects.
    fileprivate func draftMessage(in context: NSManagedObjectContext) -> DraftMessage {
        return .init(text: text, mentions: mentions.compactMap { $0.mention(in: context) })
    }
}

/// A serializable version of `Mention` that conforms to `Codable` and
/// stores a user identifier instead of a whole `UserType` value.
fileprivate struct StorableMention: Codable {

    /// The range of the mention.
    let range: NSRange
    /// The user identifier of the user being mentioned.
    let userIdentifier: UUID
    
    /// Converts the storable mention into a regular `Mention` object.
    /// The passed in `context` is needed to fetch the user object.
    func mention(in context: NSManagedObjectContext) -> Mention? {
        return ZMUser(remoteID: userIdentifier, createIfNeeded: false, in: context).map(papply(Mention.init, range))
    }

}

// MARK: - Conversation Accessors

@objc extension ZMConversation {
    
    /// Internal storage of the serialized `draftMessage`.
    @NSManaged var draftMessageData: Data?

    /// The draft message of the conversation.
    public var draftMessage: DraftMessage? {
        set {
            if let value = newValue {
                draftMessageData = try? JSONEncoder().encode(value.storable)
            } else {
                draftMessageData = nil
            }
        }
        
        get {
            guard let data = draftMessageData, let context = managedObjectContext else { return nil }
            do {
                let storable = try JSONDecoder().decode(StorableDraftMessage.self, from: data)
                return storable.draftMessage(in: context)
            } catch {
                draftMessageData = nil
                return nil
            }
        }

    }

}

// MARK: - Storable Helper

fileprivate extension UserType {
    
    // Private helper to get the user identifier for a `UserType`.
    var userIdentifier: UUID? {
        if let user = self as? ZMUser {
            return user.remoteIdentifier
        } else if let user = self as? ServiceUser {
            return user.userIdentifier
        }
        
        return nil
    }
    
}

fileprivate extension Mention {
    
    /// The storable version of the object.
    var storable: StorableMention? {
        return user.userIdentifier.map {
            StorableMention(range: range, userIdentifier: $0)
        }
    }

}

fileprivate extension DraftMessage {

    /// The storable version of the object.
    fileprivate var storable: StorableDraftMessage {
        return .init(text: text, mentions: mentions.compactMap(\.storable))
    }

}
