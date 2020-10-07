//
//  ContentView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 01/10/2020.
//

import SwiftUI
import Firebase
import Introspect

struct LauncherView: View {
    
    var body: some View {
        Home()
    }
    
    init() {
        self.retrieveUser()
    }
    
    func retrieveUser() {
        if Auth.auth().currentUser != nil {
            let uid: String! = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                let user = try? JSONDecoder().decode(ChatUser.self, from: data)
                if user != nil {
                    FirebaseManager.manager.currentUser = user!
                    
                    Database.database().reference(withPath: "online-users/\(user!.uid)").setValue(true)
                    
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LauncherView()
            .previewDevice("iPhone 11 Pro Max")
            .statusBar(hidden: false)
    }
}

struct Home: View {
    
    @State private var show = false
    @State private var status = false
    
    @State var viewModel = MainTabViewModel()
    
    var body: some View {
        VStack {
            if self.status {
                TabView {
                    LatestMessagesView()
                        .tabItem {
                            Image(systemName: "list.dash")
                            Text("Latest Messages")
                        }
                    
                    ContactsView()
                        .tabItem {
                            Image(systemName: "book")
                            Text("Contacts")
                        }
                }
                .introspectTabBarController { tabBarController in
                    viewModel.tabBarController = tabBarController
                }
            } else {
                ZStack {
                    NavigationLink(
                        destination: Register(show: self.$show)
                            .background(Color("DefaultGreen").edgesIgnoringSafeArea(.all))
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true),
                        isActive: self.$show)
                    {
                        Text("")
                    }
                    .hidden()
                    Login(show: self.$show)
                } // ZStack
            }
        } // VStack
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .background(Color("DefaultGreen").edgesIgnoringSafeArea(.all))
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { _ in
                
                self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
            }
        }
    }
}

struct ErrorView: View {
    
    @State var colour = Color.black.opacity(0.7)
    @Binding var alert: Bool
    @Binding var error: String
    
    var body: some View {
        VStack {
            HStack {
                Text(self.error == "RESET" ? "Message" : "Error")
                    .font(.title)
                    .foregroundColor(self.colour)
                    .padding(.top, 15)
            } // HStack
            .padding(.horizontal, 25)
            
            Text(self.error == "RESET" ? "Password reset email sent" : self.error)
                .foregroundColor(self.colour)
                .padding(.top)
            
            Button(action: {
                
                self.alert.toggle()
                
            }) {
                Text("Ok")
                    .foregroundColor(Color.white)
                    .padding(.vertical)
                    .frame(maxWidth: 260)
            }
            .background(Color("DefaultGreen"))
            .cornerRadius(10)
            .padding([.bottom, .top], 25)
        } // VStack
        .frame(maxWidth: 300)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal, 25)
    }
}
