//
//  ChatUser.swift
//  FirebaseApp
//
//  Created by Jack Colley on 02/09/2020.
//  Copyright © 2020 Jack. All rights reserved.
//

import Foundation

struct ChatUser: Codable, Equatable {
    let contacts: [String]?
    var blocklist: [String]?
    let token: String?
    let email: String
    let uid, username, profileImageUrl: String

    enum CodingKeys: String, CodingKey {
        case contacts, email, blocklist, profileImageUrl
        case token, uid, username
    }
    
    init() {
        self.contacts = [String]()
        self.blocklist = [String]()
        self.email = ""
        self.profileImageUrl = ""
        self.token = ""
        self.uid = ""
        self.username = ""
    }
    
    init(_ uid: String, _ username: String, _ profileImageUrl: String, _ email: String) {
        self.uid = uid
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.email = email
        self.token = nil
        self.contacts = nil
        self.blocklist = nil
    }
    
    func toAnyObject() -> Any {
        return [
            "uid" : uid,
            "username" : username,
            "email" : email,
            "profileImageUrl" : profileImageUrl,
        ]
    }
}

extension ChatUser: Identifiable {
    var id: String { return uid }
}
