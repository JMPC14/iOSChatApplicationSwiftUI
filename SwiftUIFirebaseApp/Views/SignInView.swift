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
    
    var body: some View {
        
        ZStack {
            
            ZStack(alignment: .topTrailing) {
                
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    Text("Register")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding()
                
                VStack {
                    
                    Image("image_bird")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: UIScreen.main.bounds.width / 2)
                    
                    Text("Log in to your account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    TextField("Email", text: self.$email)
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
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color.white : self.color, lineWidth: 2))
                    .padding(.top, 25)
                    .foregroundColor(.white)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            
                        }) {
                            Text("Forgot Password?")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                    }
                    .padding(.top, 10)
                    
                    Button(action: {
                        
                        self.verify()
                        
                    }) {
                        Text("Sign In")
                            .foregroundColor(Color("DefaultGreen"))
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.top, 25)
                }
                .padding(.horizontal, 25)
                .frame(maxHeight: .infinity)
            }
            
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
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
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
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
                
//                Database.database().reference(withPath: "online-users/\(user!.uid)").setValue(true)
                
                print("user retrieval success")
            }
        })
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Login(show: Binding.constant(false))
            .background(Color("DefaultGreen").ignoresSafeArea(edges: .all))
    }
}
