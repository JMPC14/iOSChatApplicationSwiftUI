//
//  ContentView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 01/10/2020.
//

import SwiftUI
import Firebase

struct LauncherView: View {
    var body: some View {
        Home()
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
    
    var body: some View {
        NavigationView {
            VStack {
                if self.status {
                    Homescreen()
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
                    }
                }
            }
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Homescreen: View {
    
    var body: some View {
        
        VStack {
            Text("Logged In")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black.opacity(0.7))
            
            Button(action: {
                
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            }) {
                Text("Log Out")
                    .foregroundColor(Color("DefaultGreen"))
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top, 25)
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
                Text("Error")
                    .font(.title)
                    .foregroundColor(self.colour)
                    .padding(.top, 15)
                
                Spacer()
            }
            .padding(.horizontal, 25)
            
            Text(self.error)
                .foregroundColor(self.colour)
                .padding(.top)
            
            Button(action: {
                
                self.alert.toggle()
                
            }) {
                Text("Cancel")
                    .foregroundColor(Color.white)
                    .padding(.vertical)
                    .frame(maxWidth: 260)
            }
            .background(Color("DefaultGreen"))
            .cornerRadius(10)
            .padding([.bottom, .top], 25)
        }
        .frame(maxWidth: 300)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal, 25)
    }
}
