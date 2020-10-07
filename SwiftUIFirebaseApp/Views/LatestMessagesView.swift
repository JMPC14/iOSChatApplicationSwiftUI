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
import Introspect

struct LatestMessagesView: View {
    
    @State var latestMessageArray = [ChatMessage]()
    
    @State var dictionary = [String : ChatUser]()
    
    @State var onlineUsers = [String]()
    
    @State var showSettings = false
    
    var body: some View {
        
        NavigationView {
            List(latestMessageArray) { message in
                let chatUser = self.dictionary[message.messageId]!
                NavigationLink(destination: ChatView(otherUser: chatUser, onlineUsers: self.$onlineUsers)) {
                    HStack {
                        // Profile picture
                        WebImage(url: URL(string: chatUser.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 55, height: 55)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                            .shadow(radius: 2)
                        
                        VStack(alignment: .leading) {
                            // Top text
                            HStack {
                                Text(chatUser.username)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 1)
                                if onlineUsers.contains(chatUser.uid) {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 10, weight: .ultraLight))
                                        .foregroundColor(Color.green)
                                }
                                Spacer()
                            }
                            .padding(.top, 5)
                            
                            Spacer()
                            
                            // Bottom text
                            Text(message.fromId == FirebaseManager.manager.currentUser.uid ? "You: \(message.text)" : "Them: \(message.text)")
                                .padding(.bottom, 5)
                                .lineLimit(1)
                        } // VStack
                        .padding(.leading, 5)
                    } // HStack
                    .onAppear {
                        showTabbar()
                        enableTouchTabbar()
                    }
                    .frame(maxHeight: 120)
                } // NavigationLink
            } // List
            .navigationBarTitle("Latest Messages")
            .navigationBarItems(leading: Button(action: {
                
            }) {
                Text("Menu")
            }, trailing: NavigationLink(destination: SettingsView(), isActive: self.$showSettings) {
                Button(action: {
                    self.showSettings = true
                }) {
                    Text("Settings")
                }
            })
        } // NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            listenForOnlineUsers()
            listenForLatestMessages()
        }
    }
    
    public func showTabbar() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("showBottomTabbar"), object: nil)
        }
    }
    
    public func enableTouchTabbar() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("enableTouchTabbar"), object: nil)
        }
    }
    
    func listenForOnlineUsers() {
        let ref = Database.database().reference()
        ref.child("online-users").observe(.childAdded, with: { snapshot in
            if snapshot.value as! Bool == true {
                onlineUsers.append(snapshot.key)
                
            }
        })
        ref.child("online-users").observe(.childChanged, with: { snapshot in
            if onlineUsers.contains(snapshot.key) && snapshot.value as! Bool == false {
                onlineUsers.removeAll(where: { $0 == snapshot.key })
                
            } else {
                onlineUsers.append(snapshot.key)
                
            }
        })
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
