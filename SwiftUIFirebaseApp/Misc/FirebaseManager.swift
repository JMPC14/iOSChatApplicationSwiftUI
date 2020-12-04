//
//  FirebaseManager.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 01/10/2020.
//

import Foundation
import UIKit

class FirebaseManager {
    static var manager = FirebaseManager()
    
    var currentUser: ChatUser
    var latestMessageSeen: String
    var token: String

    init() {
        self.currentUser = ChatUser()
        self.latestMessageSeen = String()
        self.token = ""
    }
    
    func sendPushNotification(_ to: String, _ title: String, _ body: String) {
        let payload: [String: Any] = ["title": title, "body": body, "sound": "sound.caf"]
        let paramString: [String: Any] = ["to": to,
                                          "notification": payload]
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AIzaSyDmP6Xmw9EVIRY6yLYjmgz6fbnrfgER1BQ", forHTTPHeaderField: "Authorization")

        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let data = data {
                    if let object  = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
                        NSLog("Received data: \(object))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
