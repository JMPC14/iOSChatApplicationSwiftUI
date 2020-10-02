//
//  ContentView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 01/10/2020.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11 Pro Max")
            .statusBar(hidden: false)
    }
}

struct Home: View {
    
    @State private var show = false
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: Register(show: self.$show)
                        .background(Color("DefaultGreen").edgesIgnoringSafeArea(.all))
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: self.$show)
                {
                    Text("")
                }
                .hidden()
                Login(show: self.$show)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .background(Color("DefaultGreen").edgesIgnoringSafeArea(.all))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Login: View {
    
    @State private var color = Color.white.opacity(0.7)
    @State private var email = ""
    @State private var password = ""
    @State private var visible = false
    @Binding var show: Bool
    
    var body: some View {
        
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
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Colour") : self.color, lineWidth: 2))
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
                .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color("Colour") : self.color, lineWidth: 2))
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
    }
}

struct Register: View {
    
    @State private var color = Color.white.opacity(0.7)
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var visible = false
    @State private var revisible = false
    @Binding var show: Bool
    
    var body: some View {
        
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
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Colour") : self.color, lineWidth: 2))
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
                .background(RoundedRectangle(cornerRadius: 4).stroke(self.passwordConfirm != "" ? Color("Colour") : self.color, lineWidth: 2))
                .padding(.top, 25)
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
                .padding(.top, 25)
                .foregroundColor(.white)
                
                Button(action: {
                    
                }) {
                    Text("Register")
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
    }
}
