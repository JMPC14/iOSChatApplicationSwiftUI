//
//  ChatView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 05/10/2020.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct ChatView: View {
    
    @State var messagesArray = [ChatMessage]()
    @State var writing = ""
    var otherUser: ChatUser
    @State var cid = ""
    @State var otherUserTyping = false
    @State var scrollPosition = 0
    
    @State var dummyArray = [ChatMessage(fromId: "TestFromId", messageId: "TestId", timestamp: "TestTimestamp", toId: "TestToId", text: "TestText", time: 0)]
    
    @Binding var onlineUsers: [String]
    
    var body: some View {

        VStack {
            ZStack {
                ScrollView {
                    ScrollViewReader { scroll in
                        ForEach(messagesArray) { message in
                            let index = messagesArray.firstIndex(where: { $0 == message })
                            let previousMessage = messagesArray[index! - 1 == -1 ? 0 : index! - 1]
                            let previousAuthorIsIdentical = previousMessage.fromId == message.fromId
                            let firstMessage = index == 0 ? true : false
                            let displayTime = (message.time - previousMessage.time) >= 60
                            if message.fromId == FirebaseManager.manager.currentUser.uid {
                                if displayTime || firstMessage {
                                    Text(message.timestamp)
                                        .font(.system(size: 10))
                                        .padding(.top, firstMessage == true ? 10 : 0)
                                }
                                HStack {
                                    Spacer()
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Text(message.text)
                                                .padding(5)
                                                .background(Color("LightGreen"))
                                                .cornerRadius(10)
                                        }
                                    } // VStack
                                    if !previousAuthorIsIdentical || firstMessage {
                                        WebImage(url: URL(string: FirebaseManager.manager.currentUser.profileImageUrl))
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .frame(width: 40, height: 40)
                                            .overlay(Circle().stroke(Color.green, lineWidth: 2))
                                            .shadow(radius: 1)
                                    }
                                } // HStack
                                .id(message)
                                .padding(.trailing, previousAuthorIsIdentical == true && firstMessage == false ? 48 : 0)
                                .onAppear {
                                    withAnimation {
                                        scroll.scrollTo(dummyArray.last)
                                    }
                                }
                            } else {
                                if displayTime || firstMessage {
                                    Text(message.timestamp)
                                        .font(.system(size: 10))
                                        .padding(.top, firstMessage == true ? 10 : 0)
                                }
                                HStack {
                                    let colourChange = onlineUsers.contains(otherUser.uid)
                                    if !previousAuthorIsIdentical || firstMessage {
                                        WebImage(url: URL(string: otherUser.profileImageUrl))
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .frame(width: 40, height: 40)
                                            .overlay(Circle().stroke(colourChange ? Color.green : Color.black, lineWidth: 2))
                                            .shadow(radius: 1)
                                    }
                                    VStack {
                                        HStack {
                                            Text(message.text)
                                                .padding(5)
                                                .background(Color(UIColor.systemGray5))
                                                .cornerRadius(10)
                                                .id(message.id)
                                            Spacer()
                                        }
                                    } // VStack
                                } // HStack
                                .id(message)
                                .padding(.leading, previousAuthorIsIdentical == true && firstMessage == false ? 48 : 0)
                                .onAppear {
                                    withAnimation {
                                        scroll.scrollTo(dummyArray.last)
                                    }
                                }
                            }
                        } // ForEach
                        .padding(.horizontal, 10)
                        .navigationBarTitle(self.otherUser.username, displayMode: .inline)
                        
                        ForEach(dummyArray) { i in
                            Text("Test")
                                .frame(height: 60)
                                .foregroundColor(Color.clear)
                                .id(i)
                        }
                    } // ScrollViewReader
                    
                } // ScrollView
                
                VStack {
                    Spacer()
                    VStack {
                        if self.otherUserTyping {
                            HStack {
                                Text("\(otherUser.username) is typing...")
                                    .padding(.bottom, 2)
                                    .padding(.horizontal, 10)
                                Spacer()
                            }
                            .transition(AnyTransition.opacity.animation(.linear(duration: 0.2)))
                        }
                        HStack {
                            Button(action: {
                                
                            }) {
                                Image(systemName: "camera")
                                    .font(.system(size: 22, weight: .ultraLight))
                            }
                            TextField("Enter a message...", text: self.$writing)
                                .frame(height: 15)
                                .padding(10)
                                .background(Color(red: 233.0/255, green: 234.0/255, blue: 243.0/255))
                                .cornerRadius(10)
                                .onChange(of: self.writing, perform: { text in
                                    updateTypingIndicator()
                                })
                            
                            Button(action: {
                                if writing != "" {
                                    let ref = Database.database().reference().child("conversations/\(self.cid)").childByAutoId()
                                    
                                    let date = Date()
                                    let calendar = Calendar.current
                                    var components = calendar.dateComponents([.day], from: date)
                                    let dayOfMonth = components.day
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "LLLL"
                                    let nameOfMonth = dateFormatter.string(from: date)
                                    components = calendar.dateComponents([.hour, .minute], from: date)
                                    let hour = components.hour!
                                    let minute = components.minute!
                                    var newHour = ""
                                    var newMinute = ""
                                    if hour < 10 {
                                        newHour = "0\(hour)"
                                    } else {
                                        newHour = String(hour)
                                    }
                                    if minute < 10 {
                                        newMinute = "0\(minute)"
                                    } else {
                                        newMinute = String(minute)
                                    }
                                    
                                    let chatMessage = ChatMessageNew(
                                        FirebaseManager.manager.currentUser.uid,
                                        ref.key!,
                                        self.writing,
                                        Int(NSDate().timeIntervalSince1970),
                                        "\(dayOfMonth!) \(nameOfMonth), \(newHour):\(newMinute)",
                                        self.otherUser.uid
                                    )
                                    
                                    ref.setValue(chatMessage.toAnyObject())
                                    
                                    let latestMessageRef = Database.database().reference()
                                    latestMessageRef.child("latest-messages/\(chatMessage.fromId)/\(chatMessage.toId)").setValue(chatMessage.toAnyObject())
                                    
                                    let latestMessageToRef = Database.database().reference()
                                    latestMessageToRef.child("latest-messages/\(chatMessage.toId)/\(chatMessage.fromId)").setValue(chatMessage.toAnyObject())
                                }
                                self.writing = ""
                            }) {
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: 22, weight: .ultraLight))
                            }
                            
                        } // HStack
                        .padding(.horizontal, 10)
                    } // VStack
                    .padding(.top, 4)
                    .frame(height: 60)
                    .background(Color.white.opacity(0.8)
                                    .edgesIgnoringSafeArea(.bottom))
                }
            } // ZStack
            
            
        } // VStack
        .onAppear {
            listenForMessages()
            listenForTypingIndicators()
        }
    }
    
    func listenForTypingIndicators() {
        
        func checkSnapshot(_ snapshot: DataSnapshot) {
            
            if snapshot.key == "typing" {
                if snapshot.value as! Bool == true {
                    otherUserTyping = true
                } else if snapshot.value as! Bool == false {
                    otherUserTyping = false
                }
            } else if snapshot.key == "latestMessageSeen" {
                FirebaseManager.manager.latestMessageSeen = snapshot.value as! String
            }
        }
        
        let ref = Database.database().reference(withPath: "user-messages/\(FirebaseManager.manager.currentUser.uid)/\(otherUser.uid)")
        ref.observe(.childAdded, with: { snapshot in
            checkSnapshot(snapshot)
        })
        ref.observe(.childChanged, with: { snapshot in
            checkSnapshot(snapshot)
        })
    }
    
    func updateTypingIndicator() {
        let ref = Database.database().reference(withPath: "user-messages/\(otherUser.uid)/\(FirebaseManager.manager.currentUser.uid)")
        if self.writing != "" {
            ref.child("typing").setValue(true)
        } else {
            ref.child("typing").setValue(false)
        }
    }
    
    func listenForMessages() {
        let ref = Database.database().reference().child("user-messages/\(FirebaseManager.manager.currentUser.uid)/\(otherUser.uid)/cid")
        ref.observe(.value) { snapshot in
            self.cid = snapshot.value! as! String
            let newRef = Database.database().reference()
            newRef.child("conversations/\(self.cid)").observe(.childAdded, with: { snapshot in
                guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                let a = try? JSONDecoder().decode(ChatMessage?.self, from: data)
                self.messagesArray.append(a!)
            })
        }
    }
}
