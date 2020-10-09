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
    
    @State var showNewConversation = false
    
    @State var newConversationUser = ChatUser()
    
    @State var enactNewConversation = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                if enactNewConversation {
                    NavigationLink(destination: ChatView(otherUser: newConversationUser, onlineUsers: $onlineUsers), isActive: $enactNewConversation) {}
                    .hidden()
                }
                
                List(latestMessageArray) { message in
                    let chatUser = dictionary[message.messageId]!
                    NavigationLink(destination: ChatView(otherUser: chatUser, onlineUsers: $onlineUsers)) {
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
                .navigationBarItems(leading: NavigationLink(destination: SettingsView(), isActive: $showSettings) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Text("Settings")
                    }
                }, trailing: Button(action: {
                    // New Conversation
                    showNewConversation = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 26, weight: .light))
                }
                .sheet(isPresented: $showNewConversation) {
                    NewConversation(showNewConversation: $showNewConversation, newConversationUser: $newConversationUser, enactNewConversation: $enactNewConversation)
                })
            }
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
            refreshLatestMessages(snapshot)
            })
        
        ref.child(FirebaseManager.manager.currentUser.uid).observe(.childChanged, with: { snapshot in
            refreshLatestMessages(snapshot)
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
            
            if a!.fromId == Auth.auth().currentUser?.uid {
                let ref = Database.database().reference().child("users/\(a!.toId)")
                ref.observe(.value) { snapshot in
                    guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                    let user = try? JSONDecoder().decode(ChatUser?.self, from: data)
                    
                    dictionary[a!.messageId] = user!
                    
                    var changed = false
                    
                    latestMessageArray.forEach { message in
                        if message.fromId == a!.toId || message.toId == a!.toId {
                            let index = latestMessageArray.firstIndex(where: { $0 == message })
                            latestMessageArray[index!] = a!
                            changed = true
                        }
                    }
                    
                    if !changed {
                        latestMessageArray.append(a!)
                    }
                    
                    latestMessageArray = latestMessageArray.sorted(by: { $0.time > $1.time })
                }
            } else {
                let ref = Database.database().reference().child("users/\(a!.fromId)")
                ref.observe(.value) { snapshot in
                    guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                    let user = try? JSONDecoder().decode(ChatUser?.self, from: data)
                    
                    dictionary[a!.messageId] = user!
                    
                    var changed = false
                    
                    latestMessageArray.forEach { message in
                        if message.fromId == a!.fromId || message.toId == a!.fromId {
                            let index = latestMessageArray.firstIndex(where: { $0 == message })
                            latestMessageArray[index!] = a!
                            changed = true
                        }
                    }
                    
                    if !changed {
                        latestMessageArray.append(a!)
                    }
                    
                    latestMessageArray = latestMessageArray.sorted(by: { $0.time > $1.time })
                }
            }
        }
    }
}

struct NewConversation: View {
    
    @Binding var showNewConversation: Bool
    
    @Binding var newConversationUser: ChatUser
    
    @Binding var enactNewConversation: Bool
    
    @State var contacts = [ChatUser]()
    
    var body: some View {
        VStack {
            HStack {
                Text("New Conversation")
                    .bold()
                    .font(.system(size: 32))
                    .padding()
                Spacer()
                Button(action: {
                    showNewConversation = false
                }) {
                    Text("Cancel")
                        .padding()
                }
            }
            List(contacts) { chatUser in
                HStack {
                    // Profile picture
                    WebImage(url: URL(string: chatUser.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 55, height: 55)
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        .shadow(radius: 2)
                    
                    Text(chatUser.username)
                        .fontWeight(.semibold)
                        .padding(.leading, 5)
                } // HStack
                .onTapGesture {
                    checkForConversation(chatUser)
                }
            } // List
            .navigationTitle("New Conversation")
            .onAppear {
                fetchContacts()
            }
        }
    }
    
    func fetchContacts() {
        contacts = []
        let ref = Database.database().reference()
        ref.child("users/\(FirebaseManager.manager.currentUser.uid)/contacts").observe(.childAdded, with: { snapshot in
            let newRef = Database.database().reference()
            newRef.child("users/\(snapshot.value!)").observe(.value, with: { snapshot in
                guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                let user = try? JSONDecoder().decode(ChatUser?.self, from: data)
                
                contacts.append(user!)
            })
        })
    }
    
    func checkForConversation(_ otherUser: ChatUser) {
        let ref = Database.database().reference()
        ref.child("user-messages/\(Auth.auth().currentUser!.uid)").observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.hasChild(otherUser.uid) {
                newConversationUser = otherUser
                enactNewConversation = true
                showNewConversation = false
            } else {
                let cid = UUID.init().uuidString
                ref.child("user-messages/\(Auth.auth().currentUser!.uid)/\(otherUser.uid)/cid").setValue(cid, withCompletionBlock: { error, snapshot in
                    let otherRef = Database.database().reference()
                    otherRef.child("user-messages/\(otherUser.uid)/\(Auth.auth().currentUser!.uid)/cid").setValue(cid, withCompletionBlock: { error, snapshot in
                        newConversationUser = otherUser
                        enactNewConversation = true
                        showNewConversation = false
                    })
                })
            }
        })
    }
}
