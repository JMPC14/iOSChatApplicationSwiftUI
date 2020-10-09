//
//  SettingsView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 07/10/2020.
//

import SwiftUI
import Firebase
import UIKit
import SDWebImageSwiftUI

struct SettingsView: View {
    
    var body: some View {
        List {
            NavigationLink(destination: BlocklistView()) {
                Text("Blocked Users")
                
                /* Bugged: https://stackoverflow.com/questions/63945077/swiftui-multiple-navigationlinks-in-form-sheet-entry-stays-highlighted
                 https://stackoverflow.com/questions/63934037/swiftui-navigationlink-cell-in-a-form-stays-highlighted-after-detail-pop */
            }
            
            HStack {
                Text("Sign Out")
                    .foregroundColor(Color.red)
                Spacer()
            }
            .onTapGesture {
                do { try Auth.auth().signOut() }
                catch { print("sign out failed") }
                Database.database().reference(withPath: "online-users/\(FirebaseManager.manager.currentUser.uid)").setValue(false)
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct BlocklistView: View {
    
    @State var blocklist = [ChatUser]()
    
    var body: some View {
        VStack {
            List(blocklist) { chatUser in
                HStack {
                    // Profile picture
                    WebImage(url: URL(string: chatUser.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 55, height: 55)
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        .shadow(radius: 2)
                    
                    // Username
                    Text(chatUser.username)
                        .fontWeight(.semibold)
                        .padding(.leading, 5)
                } // HStack
                // Remove user from block list
                
                .onTapGesture {
                    
                    if FirebaseManager.manager.currentUser.blocklist!.contains(chatUser.uid) {
                        FirebaseManager.manager.currentUser.blocklist!.removeAll(where: {$0 == chatUser.uid})
                        blocklist.removeAll(where: {$0 == chatUser})
                    }

                    let ref = Database.database().reference()
                    ref.child("users/\(Auth.auth().currentUser!.uid)/blocklist").setValue(FirebaseManager.manager.currentUser.blocklist)
                }
            } // List
            
            if blocklist.isEmpty {
                VStack {
                    Text("You have no blocked users!")
                    Spacer()
                }
            }
        }
        .navigationBarTitle("Blocked Users")
        .onAppear {
            fetchBlocklist()
        }
    }
    
    func fetchBlocklist() {
        blocklist = []
        FirebaseManager.manager.currentUser.blocklist?.forEach { uid in
            let newRef = Database.database().reference()
            newRef.child("users/\(uid)").observe(.value) { snapshot in
                guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                let user = try? JSONDecoder().decode(ChatUser?.self, from: data)
                blocklist.append(user!)
                blocklist = blocklist.sorted(by: { $1.username.lowercased() > $0.username.lowercased() })
            }
        }
    }
}
