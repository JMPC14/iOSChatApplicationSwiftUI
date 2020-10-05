//
//  ChatUser.swift
//  FirebaseApp
//
//  Created by Jack Colley on 02/09/2020.
//  Copyright © 2020 Jack. All rights reserved.
//

import Foundation

struct ChatUser: Codable {
    let contacts: [String]?
    let blocklist: [String]?
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
}
