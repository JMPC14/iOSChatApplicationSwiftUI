//
//  ChatMessage.swift
//  FirebaseApp
//
//  Created by Jack Colley on 07/09/2020.
//  Copyright © 2020 Jack. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class ChatMessage: Decodable, Encodable {
    var fromId: String = ""
    var id: String = ""
    var text: String = ""
    var time: Int = 1
    var timestamp: String = ""
    var toId: String = ""
    var imageUrl: String? = nil
    var fileUrl: String? = nil
    var fileType: String? = nil
    
    init(_ fromId: String, _ id: String, _ text: String, _ time: Int, _ timestamp: String, _ toId: String) {
        self.fromId = fromId
        self.id = id
        self.text = text
        self.time = time
        self.timestamp = timestamp
        self.toId = toId
    }
    
    init(_ fromId: String, _ id: String, _ text: String, _ time: Int, _ timestamp: String, _ toId: String, _ imageUrl: String) {
        self.fromId = fromId
        self.id = id
        self.text = text
        self.time = time
        self.timestamp = timestamp
        self.toId = toId
        self.imageUrl = imageUrl
    }
    
    init(fromId: String, id: String, text: String, time: Int, timestamp: String, toId: String, fileUrl: String) {
        self.fromId = fromId
        self.id = id
        self.text = text
        self.time = time
        self.timestamp = timestamp
        self.toId = toId
        self.fileUrl = fileUrl
    }
}
