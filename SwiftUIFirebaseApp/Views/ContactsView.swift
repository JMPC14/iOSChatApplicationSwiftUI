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
    @State var showSettings = false
    
    var body: some View {
        NavigationView {
            VStack {
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
                } // List
                .navigationTitle("Contacts")
                .navigationBarItems(leading: NavigationLink(destination: SettingsView(), isActive: $showSettings) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Text("Settings")
                    }
                },
                trailing: NavigationLink(destination: NewContactView(contacts: $contacts, addingNewContact: $addingNewContact), isActive: $addingNewContact) {
                    Button(action: {
                        addingNewContact = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 26, weight: .light))
                    }
                })
                
                if contacts.isEmpty {
                    VStack {
                        Text("You have no contacts!")
                        Spacer()
                    }
                }
            }
        } // NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            fetchContacts()
        }
    }
    
    func fetchContacts() {
        contacts = []
        FirebaseManager.manager.currentUser.contacts?.forEach { uid in
            let newRef = Database.database().reference()
            newRef.child("users/\(uid)").observe(.value) { snapshot in
                guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                let user = try? JSONDecoder().decode(ChatUser?.self, from: data)
                contacts.append(user!)
                contacts = contacts.sorted(by: { $1.username.lowercased() > $0.username.lowercased() })
            }
        }
    }
}

struct NewContactView: View {
    
    @State var users = [ChatUser]()
    @State var filter = ""
    @State var filteredUsers = [ChatUser]()
    @Binding var contacts: [ChatUser]
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
                    .autocapitalization(.none)
                    .onChange(of: filter) { value in
                        filteredUsers = [ChatUser]()
                        users.forEach { user in
                            if user.username.lowercased().contains(filter.lowercased()) {
                                filteredUsers.append(user)
                            }
                        }
                    }
            } // HStack
            .padding(.horizontal, 15)
            
            List(filter.isEmpty ? users : filteredUsers) { chatUser in
                HStack {
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
                    var contactsUidList = [String]()
                    contacts.forEach { contact in
                        contactsUidList.append(contact.uid)
                    }
                    
                    contactsUidList.append(chatUser.uid)
                    contacts.append(chatUser)
                    
                    if FirebaseManager.manager.currentUser.contacts == nil {
                        FirebaseManager.manager.currentUser.contacts = [String]()
                    }
                    FirebaseManager.manager.currentUser.contacts?.append(chatUser.uid)
                    
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
            
            if filter != "" && filteredUsers.isEmpty {
                VStack {
                    Text("No users found!")
                    Spacer()
                }
            }
        } // VStack
    }
    
    func fetchUsers() {
        users = []
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
