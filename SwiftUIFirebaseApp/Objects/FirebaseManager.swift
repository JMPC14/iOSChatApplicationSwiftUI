//
//  FirebaseManager.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 01/10/2020.
//

import Foundation

class FirebaseManager {
    static var manager = FirebaseManager()
    
    var currentUser: ChatUser
    var onlineUsers: [String]
    var latestMessageSeen: String

    init() {
        self.currentUser = ChatUser()
        self.onlineUsers = [String]()
        self.latestMessageSeen = String()
    }
}

