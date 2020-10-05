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
    
    var body: some View {
        VStack {
            List(messagesArray) { message in
                if message.fromId == FirebaseManager.manager.currentUser.uid {
                    HStack {
                        Spacer()
                        Text(message.text)
                            .padding(5)
                            .background(Color.green)
                            .cornerRadius(10)
                        WebImage(url: URL(string: FirebaseManager.manager.currentUser.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                            .shadow(radius: 2)
                    } // HStack
                } else {
                    HStack {
                        WebImage(url: URL(string: otherUser.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                            .shadow(radius: 2)
                        Text(message.text)
                            .padding(5)
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                    } // HStack
                }
            } // List
            .listStyle(SidebarListStyle())
            .listRowInsets(EdgeInsets())
            
            HStack {
                TextField("Enter a message...", text: self.$writing)
                    .padding(10)
                    .background(Color(red: 233.0/255, green: 234.0/255, blue: 243.0/255))
                    .cornerRadius(10)
                
                Button(action: {
                    
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 30, weight: .ultraLight))
                }
                
            } // HStack
            .padding(.horizontal, 10)
        } // VStack
        .onAppear {
            listenForMessages()
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

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Spacer()
            Text(".text")
            WebImage(url: URL(string: FirebaseManager.manager.currentUser.profileImageUrl))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 30, height: 30)
                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                .shadow(radius: 2)
        } // HStack
    }
}
