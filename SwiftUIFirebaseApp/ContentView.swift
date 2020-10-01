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
        ZStack {
            VStack {
                Login()
            }
            .padding(.top, 30)
        }
        .background(Color("DefaultGreen"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11 Pro Max")
    }
}

struct Login: View {
    
    @State private var color = Color.white.opacity(0.7)
    @State private var email = ""
    @State private var password = ""
    @State private var visible = false
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            GeometryReader { geometry in
                VStack {
                    
                    Spacer()
                    
                    Image("image_bird")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200.0, height: 150.0)
                    
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
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
            }
            
            Button(action: {
                
            }) {
                Text("Register")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
    
}
