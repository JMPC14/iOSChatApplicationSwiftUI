//
//  RegisterView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 02/10/2020.
//

import SwiftUI
import Firebase

struct Register: View {
    
    @State private var color = Color.white.opacity(0.7)
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var visible = false
    @State private var revisible = false
    @Binding var show: Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View {
        ZStack {
            ZStack(alignment: .topLeading) {
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .padding()
                
                VStack {
                    Image("image_bird")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200.0, height: 150.0)
                    
                    Text("Create a new account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Colour") : self.color, lineWidth: 2))
                        .padding(.top, 15)
                        .foregroundColor(.white)
                    
                    TextField("Username", text: self.$username)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Colour") : self.color, lineWidth: 2))
                        .padding(.top, 15)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 15) {
                        VStack {
                            if self.visible {
                                TextField("Password", text: self.$password)
                            } else {
                                SecureField("Password", text: self.$password)
                            }
                        }
                        
                        Button(action: {
                            
                            self.visible.toggle()
                            
                        }) {
                            Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(self.color)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.passwordConfirm != "" ? Color("Colour") : self.color, lineWidth: 2))
                    .padding(.top, 15)
                    .foregroundColor(.white)
                    
                    HStack(spacing: 15) {
                        VStack {
                            if self.revisible {
                                TextField("Confirm Password", text: self.$passwordConfirm)
                            } else {
                                SecureField("Confirm Password", text: self.$passwordConfirm)
                            }
                        }
                        
                        Button(action: {
                            
                            self.revisible.toggle()
                            
                        }) {
                            Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(self.color)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color("Colour") : self.color, lineWidth: 2))
                    .padding(.top, 15)
                    .foregroundColor(.white)
                    
                    Button(action: {
                        
                        self.verify()
                        
                    }) {
                        Text("Register")
                            .foregroundColor(Color("DefaultGreen"))
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.top, 25)
                } // VStack
                .padding(.horizontal, 25)
                .frame(maxHeight: .infinity)
            } // ZStack
            
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }
        } // ZStack
    }
    
    func verify() {
        if self.email != "" && self.username != "" && self.password != "" && self.passwordConfirm != "" &&
            self.password == self.passwordConfirm {
            Auth.auth().createUser(withEmail: self.email, password: self.password, completion: { result, error in
                if error != nil {
                    // Error
                    self.error = error!.localizedDescription
                    print(self.error)
                    self.alert.toggle()
                } else {
                    // Register
                    self.register()
                    print("new user created")
                }
            })
        } else {
            if self.password != self.passwordConfirm {
                self.error = "Passwords do not match."
            } else {
                self.error = "Please enter an email and password."
            }
            self.alert.toggle()
        }
    }
    
    func register() {
        let user = ChatUser(
            Auth.auth().currentUser!.uid,
            self.username,
            "https://firebasestorage.googleapis.com/v0/b/chatapplication-524a9.appspot.com/o/images%2FDog%20Placeholder.jpg?alt=media&token=6f70d796-7da0-4d5f-965e-e5cc2c161106",
            self.email
        )
        Database.database().reference().child("users").child(user.uid).setValue(user.toAnyObject())
        let newRef = Database.database().reference()
        newRef.child("users/\(user.uid)").observe(.value, with: { snapshot in
            guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
            let user = try? JSONDecoder().decode(ChatUser.self, from: data)
            FirebaseManager.manager.currentUser = user!
            print("new user retrieved")
            UserDefaults.standard.set(true, forKey: "status")
            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
        })
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Register(show: Binding.constant(false))
            .background(Color("DefaultGreen").ignoresSafeArea(edges: .all))
    }
}
