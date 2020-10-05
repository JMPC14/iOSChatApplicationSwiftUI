//
//  LatestMessagesView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 02/10/2020.
//

import SwiftUI
import UIKit
import Firebase
import SDWebImageSwiftUI

struct LatestMessagesView: View {
    
    @State var latestMessageArray = [ChatMessage]()
    
    @State var dictionary = [String : ChatUser]()
    
    var body: some View {
        
        NavigationView {
            List(latestMessageArray) { message in
                NavigationLink(destination: ChatView()) {
                    HStack {
                        // Profile picture
                        let chatUser = self.dictionary[message.messageId]!
                        WebImage(url: URL(string: chatUser.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 55, height: 55)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                            .shadow(radius: 2)
                            
                        VStack(alignment: .leading) {
                            // Top text
                            Text(chatUser.username)
                                .fontWeight(.semibold)
                                .padding(.bottom, 1)
                            
                            // Bottom text
                            Text(message.text)
                        } // VStack
                        .padding(.leading, 5)
                    } // HStack
                    .frame(maxHeight: 120)
                } // NavigationLink
            } // List
            .navigationBarTitle("Latest Messages")
        } // NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            listenForLatestMessages()
        }
    }
    
    func listenForLatestMessages() {
        self.latestMessageArray = [ChatMessage]()
        let ref = Database.database().reference().child("latest-messages")
        ref.child(FirebaseManager.manager.currentUser.uid).observe(.childAdded, with: { snapshot in
            self.refreshLatestMessages(snapshot)
            })
        
        ref.child(FirebaseManager.manager.currentUser.uid).observe(.childChanged, with: { snapshot in
            self.refreshLatestMessages(snapshot)
        })
    }
    
    func refreshLatestMessages(_ snapshot: DataSnapshot) {
        guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
        let a = try? JSONDecoder().decode(ChatMessage?.self, from: data)
        
        if a != nil {
            if FirebaseManager.manager.currentUser.blocklist != nil {
                if FirebaseManager.manager.currentUser.blocklist!.contains(a!.fromId) || FirebaseManager.manager.currentUser.blocklist!.contains(a!.toId) {
                    return
                }
            }
            
            if a!.fromId == Auth.auth().currentUser!.uid {
                let ref = Database.database().reference().child("users/\(a!.toId)")
                ref.observe(.value) { snapshot in
                    guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                    let user = try? JSONDecoder().decode(ChatUser?.self, from: data)
                    
                    self.dictionary[a!.messageId] = user!
                    
                    var changed = false
                    
                    self.latestMessageArray.forEach { message in
                        if message.fromId == a!.toId || message.toId == a!.toId {
                            let index = self.latestMessageArray.firstIndex(where: { $0 == message })
                            self.latestMessageArray[index!] = a!
                            changed = true
                        }
                    }
                    
                    if !changed {
                        self.latestMessageArray.append(a!)
                    }
                    
                    self.latestMessageArray = self.latestMessageArray.sorted(by: { $0.time > $1.time })
                }
            } else {
                let ref = Database.database().reference().child("users/\(a!.fromId)")
                ref.observe(.value) { snapshot in
                    guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                    let user = try? JSONDecoder().decode(ChatUser?.self, from: data)
                    
                    self.dictionary[a!.messageId] = user!
                    
                    var changed = false
                    
                    self.latestMessageArray.forEach { message in
                        if message.fromId == a!.fromId || message.toId == a!.fromId {
                            let index = self.latestMessageArray.firstIndex(where: { $0 == message })
                            self.latestMessageArray[index!] = a!
                            changed = true
                        }
                    }
                    
                    if !changed {
                        self.latestMessageArray.append(a!)
                    }
                    
                    self.latestMessageArray = self.latestMessageArray.sorted(by: { $0.time > $1.time })
                }
            }
        }
    }
}

struct LatestMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        LatestMessagesView()
            .previewDevice("iPhone 11 Pro Max")
    }
}
