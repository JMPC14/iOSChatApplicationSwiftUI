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

class ChatMessageNew: Codable {
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
    
    init(_ fromId: String, _ id: String, _ text: String, _ time: Int, _ timestamp: String, _ toId: String, _ fileUrl: String, _ fileType: String) {
        self.fromId = fromId
        self.id = id
        self.text = text
        self.time = time
        self.timestamp = timestamp
        self.toId = toId
        self.fileUrl = fileUrl
        self.fileType = fileType
    }
    
    func toAnyObject() -> Any {
        if imageUrl != nil {
            return [
                "fromId" : fromId,
                "id" : id,
                "text" : text,
                "time" : time,
                "timestamp" : timestamp,
                "toId" : toId,
                "imageUrl" : imageUrl!
            ]
        } else if fileUrl != nil {
            return [
                "fromId" : fromId,
                "id" : id,
                "text" : text,
                "time" : time,
                "timestamp" : timestamp,
                "toId" : toId,
                "fileUrl" : fileUrl!,
                "fileType" : fileType!
            ]
        } else {
            return [
                "fromId" : fromId,
                "id" : id,
                "text" : text,
                "time" : time,
                "timestamp" : timestamp,
                "toId" : toId
            ]
        }
    }
}
