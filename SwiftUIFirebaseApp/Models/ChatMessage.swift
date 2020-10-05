//
//  ChatMessage.swift
//  FirebaseApp
//
//  Created by Jack Colley on 07/09/2020.
//  Copyright © 2020 Jack. All rights reserved.
//

import Foundation
import Firebase

struct ChatMessage: Codable, Equatable {
    
    let fromId, messageId, timestamp, toId, text: String
    let time: Int

    enum CodingKeys: String, CodingKey {
        case fromId, text, time, timestamp, toId
        case messageId = "id"
    }
}

extension ChatMessage: Identifiable {
    var id: String { return messageId }
}
