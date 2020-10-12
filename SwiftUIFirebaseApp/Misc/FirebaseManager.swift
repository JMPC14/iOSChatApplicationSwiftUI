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
    var latestMessageSeen: String

    init() {
        self.currentUser = ChatUser()
        self.latestMessageSeen = String()
    }
}
