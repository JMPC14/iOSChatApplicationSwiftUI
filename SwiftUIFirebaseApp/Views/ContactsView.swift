//
//  ContactsView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 07/10/2020.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct ContactsView: View {
    
    @State var contacts = [ChatUser]()
    
    @State var addingNewContact = false
    
    var body: some View {
        NavigationView {
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
                    
                    VStack(alignment: .leading) {
                        // Top text
                        HStack {
                            Text(chatUser.username)
                                .fontWeight(.semibold)
                                .padding(.bottom, 1)
                        }
                        .padding(.top, 5)
                    } // VStack
                    .padding(.leading, 5)
                } // HStack
            } // List
            .navigationTitle("Contacts")
            .navigationBarItems(trailing: NavigationLink(destination: NewContactView(contacts: $contacts, addingNewContact: $addingNewContact), isActive: $addingNewContact) {
                Button(action: {
                    addingNewContact = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 26, weight: .light))
                }
            })
        } // NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            fetchContacts()
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
}

struct NewContactView: View {
    
    @State var users = [ChatUser]()
    
    @Binding var contacts: [ChatUser]
    
    @State var filter = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var addingNewContact: Bool
    
    var body: some View {
        VStack {
            HStack {
                TextField("Filter users...", text: $filter)
                    .frame(height: 15)
                    .padding(10)
                    .background(Color(red: 233.0/255, green: 234.0/255, blue: 243.0/255))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 15)
            
            List(users) { chatUser in
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
                        }
                        .padding(.top, 5)
                    } // VStack
                    .padding(.leading, 5)
                } // HStack
                .onTapGesture {
                    // Add user
                    var contactsUidList = [String]()
                    contacts.forEach { contact in
                        contactsUidList.append(contact.uid)
                    }
                    
                    contactsUidList.append(chatUser.uid)
                    
                    let ref = Database.database().reference()
                    ref.child("users/\(Auth.auth().currentUser!.uid)/contacts").setValue(contactsUidList) { error, reference in
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            } // List
            .navigationTitle("Add Contact")
            .onAppear {
                fetchUsers()
            }
        }
    }
    
    func fetchUsers() {
        let ref = Database.database().reference()
        ref.child("users").observe(.childAdded, with: { snapshot in
            guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
            let user = try? JSONDecoder().decode(ChatUser?.self, from: data)
            if user!.uid != Auth.auth().currentUser?.uid && !contacts.contains(user!) {
                users.append(user!)
            }
        })
    }
}
