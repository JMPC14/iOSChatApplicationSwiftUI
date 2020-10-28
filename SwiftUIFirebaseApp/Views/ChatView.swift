//
//  ChatView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 05/10/2020.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import UIKit

struct ChatView: View {
    
    @State var messagesArray = [ChatMessage]()
    @State var writing = ""
    var otherUser: ChatUser
    @State var cid = ""
    @State var otherUserTyping = false
    @State var dummyArray = [ChatMessage()]
    @Binding var onlineUsers: [String]
    @Environment(\.openURL) var openURL
    @State var showAlert = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var showPhotoLibrary = false
    @State private var image = UIImage()
    @State private var attachedImageUrl = ""
    
    var body: some View {

        VStack {
            ZStack {
                ScrollView {
                    ScrollViewReader { scroll in
                        ForEach(messagesArray) { message in
                            let index = messagesArray.firstIndex(where: { $0 == message })
                            let previousMessage = messagesArray[index! - 1 == -1 ? 0 : index! - 1]
                            let previousAuthorIsIdentical = previousMessage.fromId == message.fromId
                            let isFirstMessage = index == 0 ? true : false
                            let displayTime = (message.time - previousMessage.time) >= 60
                            // Chat Scroll View
                            if message.fromId == FirebaseManager.manager.currentUser.uid {
                                // From Message
                                if displayTime || isFirstMessage {
                                    Text(message.timestamp)
                                        .font(.system(size: 10))
                                        .padding(.top, isFirstMessage ? 10 : 0)
                                }
                                HStack {
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        if message.imageUrl != nil {
                                            WebImage(url: URL(string: message.imageUrl!))
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(8)
                                                .frame(width: UIScreen.screenWidth * 0.3)
                                                .padding(.trailing, message.text == "" ? 8 : 0)
                                                .shadow(radius: 2)
                                                .onTapGesture {
                                                    openURL(URL(string: message.imageUrl!)!)
                                                }
                                        }
                                        HStack {
                                            if message.text != "" {
                                                Text(message.text)
                                                    .padding(5)
                                                    .background(Color("LightGreen"))
                                                    .cornerRadius(10)
                                            }
                                        } // HStack
                                    } // VStack
                                    .padding(.trailing, previousAuthorIsIdentical && isFirstMessage == false && displayTime == false ? 48 : 0)
                                    
                                    if !previousAuthorIsIdentical || isFirstMessage || displayTime {
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
                                .onAppear {
                                    withAnimation {
                                        scroll.scrollTo(dummyArray.last)
                                    }
                                }
                            } else {
                                // To Message
                                if displayTime || isFirstMessage {
                                    Text(message.timestamp)
                                        .font(.system(size: 10))
                                        .padding(.top, isFirstMessage ? 10 : 0)
                                }
                                HStack {
                                    let colourChange = onlineUsers.contains(otherUser.uid)
                                    if !previousAuthorIsIdentical || isFirstMessage || displayTime {
                                        WebImage(url: URL(string: otherUser.profileImageUrl))
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .frame(width: 40, height: 40)
                                            .overlay(Circle().stroke(colourChange ? Color.green : Color.black, lineWidth: 2))
                                            .shadow(radius: 1)
                                    }
                                    VStack(alignment: .leading) {
                                        if message.imageUrl != nil {
                                            WebImage(url: URL(string: message.imageUrl!))
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(8)
                                                .frame(width: UIScreen.screenWidth * 0.3)
                                                .padding(.leading, message.text == "" ? 8 : 0)
                                                .shadow(radius: 2)
                                                .onTapGesture {
                                                    openURL(URL(string: message.imageUrl!)!)
                                                }
                                        }
                                        HStack {
                                            if message.text != "" {
                                                Text(message.text)
                                                    .padding(5)
                                                    .background(Color(UIColor.systemGray5))
                                                    .cornerRadius(10)
                                            }
                                        } // HStack
                                    } // VStack
                                    .padding(.leading, previousAuthorIsIdentical && isFirstMessage == false && displayTime == false ? 48 : 0)
                                    
                                    Spacer()
                                } // HStack
                                .id(message)
                                .onAppear {
                                    let lastMessage = messagesArray.last
                                    if lastMessage == message {
                                        let ref = Database.database().reference(withPath: "user-messages/\(otherUser.uid)/\(FirebaseManager.manager.currentUser.uid)")
                                        ref.child("latestMessageSeen").setValue(message.id)
                                    }
                                    withAnimation {
                                        scroll.scrollTo(dummyArray.last)
                                    }
                                }
                                .onTapGesture {
                                    // Show Alert
                                    showAlert.toggle()
                                }
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text(otherUser.username),
                                        message: Text("Do you want to block this user?"),
                                        primaryButton: .destructive(Text("Yes"), action: {
                                            // Block
                                            if FirebaseManager.manager.currentUser.blocklist == nil {
                                                FirebaseManager.manager.currentUser.blocklist = [String]()
                                            }
                                            
                                            FirebaseManager.manager.currentUser.blocklist?.append(otherUser.uid)
                                            
                                            let blockRef = Database.database().reference().child("users/\(Auth.auth().currentUser!.uid)")
                                            blockRef.child("blocklist").setValue(FirebaseManager.manager.currentUser.blocklist, withCompletionBlock: { error, snapshot in
                                                presentationMode.wrappedValue.dismiss()
                                            })
                                        }),
                                        secondaryButton: .cancel(Text("No"), action: {
                                            
                                        })
                                    )
                                }
                            }
                        } // ForEach
                        .padding(.horizontal, 10)
                        .navigationBarTitle(otherUser.username)
                        
                        ForEach(dummyArray) { i in
                            Text("Test")
                                .frame(height: 70)
                                .foregroundColor(Color.clear)
                                .id(i)
                        }
                    } // ScrollViewReader
                } // ScrollView
                
                // Chat Message Bar
                VStack {
                    Spacer()
                    
                    VStack {
                        HStack {
                            Button(action: {
                                showPhotoLibrary = true
                            }) {
                                Image(systemName: "camera")
                                    .font(.system(size: 22, weight: .ultraLight))
                            }
                            
                            TextField("Enter a message...", text: $writing)
                                .frame(height: 15)
                                .padding(10)
                                .background(Color(red: 233.0/255, green: 234.0/255, blue: 243.0/255))
                                .cornerRadius(10)
                                .onChange(of: writing, perform: { text in
                                    updateTypingIndicator()
                                })
                            
                            Button(action: {
                                let ref = Database.database().reference().child("conversations/\(cid)").childByAutoId()
                                
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
                                
                                var chatMessage = ChatMessage(
                                    FirebaseManager.manager.currentUser.uid,
                                    ref.key!,
                                    writing,
                                    Int(NSDate().timeIntervalSince1970),
                                    "\(dayOfMonth!) \(nameOfMonth), \(newHour):\(newMinute)",
                                    otherUser.uid
                                )
                                
                                if attachedImageUrl != "" {
                                    chatMessage.imageUrl = attachedImageUrl
                                }
                                
                                ref.setValue(chatMessage.toAnyObject())
                                
                                let latestMessageRef = Database.database().reference()
                                latestMessageRef.child("latest-messages/\(chatMessage.fromId)/\(chatMessage.toId)").setValue(chatMessage.toAnyObject())
                                
                                let latestMessageToRef = Database.database().reference()
                                latestMessageToRef.child("latest-messages/\(chatMessage.toId)/\(chatMessage.fromId)").setValue(chatMessage.toAnyObject())
                                
                                attachedImageUrl = ""
                                image = UIImage()
                                writing = ""
                            }) {
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: 22, weight: .ultraLight))
                            }
                            .disabled(writing == "" && attachedImageUrl == "")
                            
                        } // HStack
                        .padding(.horizontal, 10)
                        .offset(y: 5)
                        
                        HStack {
                            if otherUserTyping {
                                Group {
                                    Text(otherUser.username)
                                        .fontWeight(.bold) +
                                        Text(" is typing...")
                                }
                                .offset(y: 3)
                                .padding(.horizontal, 40)
                                .transition(AnyTransition.opacity.animation(.linear(duration: 0.1)))
                            } else {
                                Text("")
                                    .padding(.bottom, 2)
                                    .padding(.horizontal, 40)
                                    .opacity(0.0)
                            }
                            Spacer()
                        }
                        .frame(height: 25)
                    } // VStack
                    .padding(.top, 4)
                    .frame(height: 70)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.8), .white]), startPoint: .top, endPoint: .bottom)
                                    .frame(height: 70)
                                    .edgesIgnoringSafeArea(.bottom))
                } // VStack
            } // ZStack
        } // VStack
        .sheet(isPresented: $showPhotoLibrary) {
            ImagePicker(selectedImage: $image, attachedImageUrl: $attachedImageUrl, sourceType: .photoLibrary)
        }
        .onAppear {
            listenForMessages()
            listenForTypingIndicators()
        }
    }
    
    public func hideTabbar() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("hideBottomTabbar"), object: nil)
        }
    }
    
    public func disableTouchTabbar() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("disableTouchTabbar"), object: nil)
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
        if writing != "" {
            ref.child("typing").setValue(true)
        } else {
            ref.child("typing").setValue(false)
        }
    }
    
    func listenForMessages() {
        let ref = Database.database().reference().child("user-messages/\(FirebaseManager.manager.currentUser.uid)/\(otherUser.uid)/cid")
        ref.observe(.value) { snapshot in
            cid = snapshot.value! as! String
            let newRef = Database.database().reference()
            newRef.child("conversations/\(self.cid)").observe(.childAdded, with: { snapshot in
                guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                let message = try? JSONDecoder().decode(ChatMessage?.self, from: data)
                messagesArray.append(message!)
            })
        }
    }
}
