//
//  ChatUser.swift
//  FirebaseApp
//
//  Created by Jack Colley on 02/09/2020.
//  Copyright © 2020 Jack. All rights reserved.
//

import Foundation

class ChatUser: Decodable, Encodable {
    var uid: String = ""
    var username: String = ""
    var profileImageUrl: String = ""
    var email: String = ""
    var token: String? = ""
    var contacts: [String]? = [String]()
    var blocklist: [String]? = [String]()
}
