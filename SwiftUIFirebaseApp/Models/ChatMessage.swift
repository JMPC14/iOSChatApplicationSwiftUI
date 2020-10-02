//
//  ChatMessage.swift
//  FirebaseApp
//
//  Created by Jack Colley on 07/09/2020.
//  Copyright © 2020 Jack. All rights reserved.
//

import Foundation
import Firebase

struct ChatMessage: Codable {
    
    let fromID, messageId, text: String
    let time: Int
    let timestamp, toID: String

    enum CodingKeys: String, CodingKey {
        case fromID = "fromId"
        case text, time, timestamp
        case toID = "toId"
        case messageId = "id"
    }
}

extension ChatMessage: Identifiable {
    var id: String { return messageId }
}
