//
//  SignInView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 02/10/2020.
//

import SwiftUI
import Firebase

struct Login: View {
    
    @State private var color = Color.white.opacity(0.7)
    @State private var email = ""
    @State private var password = ""
    @State private var visible = false
    
    @Binding var show: Bool
    
    @State var alert = false
    @State var error = ""
    
    @State var resettingPassword = false
    
    var body: some View {
        
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        
                        self.show.toggle()
                        
                    }) {
                        Text("Register")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()
                } // HStack
                
                Spacer()
            } // VStack
            
            ZStack {
                VStack {
                    Image("image_bird")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: UIScreen.screenWidth / 2)
                    
                    Text("Log in to your account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.white : self.color, lineWidth: 2))
                        .padding(.top, 25)
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
                    } // HStack
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color.white : self.color, lineWidth: 2))
                    .padding(.top, 25)
                    .foregroundColor(.white)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            
                            self.resettingPassword = true
                            
                        }) {
                            Text("Forgot Password?")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                    } // HStack
                    .padding(.top, 10)
                    
                    Button(action: {
                        
                        self.verify()
                        
                    }) {
                        Text("Sign In")
                            .foregroundColor(Color("DefaultGreen"))
                            .padding(.vertical)
                            .frame(width: UIScreen.screenWidth - 50)
                    }
                    .frame(maxWidth: 400)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.top, 25)
                } // VStack
                .frame(maxWidth: 400, maxHeight: .infinity)
                .padding(.horizontal, 25)
            } // ZStack
            .frame(width: UIScreen.screenWidth)
            .disabled(alert || resettingPassword)
            
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }
            
            if self.resettingPassword {
                ResetPassword(resettingPassword: self.$resettingPassword)
            }
        } // ZStack
    }
    
    func verify() {
        if self.email != "" && self.password != "" {
            Auth.auth().signIn(withEmail: self.email, password: self.password) { result, error in
                if error != nil {
                    // Error
                    self.error = error!.localizedDescription
                    self.alert.toggle()
                } else {
                    // User found
                    self.login()
                    print("login success")
                    UserDefaults.standard.set(true, forKey: "status")
                }
            }
        } else {
            self.error = "Please enter an email and password."
            self.alert.toggle()
        }
    }
    
    func login() {
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

struct ResetPassword: View {
    
    @State private var email = ""
    @Binding var resettingPassword: Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View {
        VStack {
            TextField("Enter your email address", text: self.$email)
                .autocapitalization(.none)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.white : Color.white.opacity(0.7), lineWidth: 2))
                .padding(.top, 25)
                .foregroundColor(.black)
            
            Button(action: {
                
                if self.email != "" {
                    Auth.auth().fetchSignInMethods(forEmail: self.email) { result, error in
                        if result != nil {
                            Auth.auth().sendPasswordReset(withEmail: self.email) { error in
                                if error != nil {
                                    self.alert = true
                                    self.error = "Email address is invalid."
                                } else {
                                    self.resettingPassword.toggle()
                                    self.alert = true
                                    self.error = "RESET"
                                }
                            }
                        } else {
                            self.alert = true
                            self.error = "Email address does not exist."
                        }
                    }
                } else {
                    self.alert.toggle()
                    self.error = "Please enter an email address."
                }
                
            }) {
                Text("Reset Password")
                    .foregroundColor(Color.white)
                    .padding(.vertical)
            }
            .frame(maxWidth: 260)
            .background(Color("DefaultGreen"))
            .cornerRadius(10)
            .padding(.top, 25)
            
            Button(action: {
                
                self.resettingPassword = false
                
            }) {
                Text("Cancel")
                    .foregroundColor(Color("DefaultGreen"))
                    .padding(.vertical)
            }
        } // VStack
        .frame(maxWidth: 300)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal, 25)
        
        if self.alert {
            ErrorView(alert: self.$alert, error: self.$error)
        }
    }
}
