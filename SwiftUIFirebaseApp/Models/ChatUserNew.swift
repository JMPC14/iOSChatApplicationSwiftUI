//
//  ChatUserNew.swift
//  FirebaseApp
//
//  Created by Jack Colley on 10/09/2020.
//  Copyright © 2020 Jack. All rights reserved.
//

import Foundation

class ChatUserNew: Codable {
    var uid: String = ""
    var username: String = ""
    var profileImageUrl: String = ""
    var email: String = ""
    var token: String? = ""
    var contacts: [String]? = nil
    var blocklist: [String]? = nil
    
    init(_ uid: String, _ username: String, _ profileImageUrl: String, _ email: String) {
        self.uid = uid
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.email = email
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
