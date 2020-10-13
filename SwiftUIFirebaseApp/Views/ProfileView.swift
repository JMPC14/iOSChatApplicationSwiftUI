//
//  ProfileView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 08/10/2020.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct ProfileView: View {
    
    var body: some View {
        ZStack {
            VStack {
                WebImage(url: URL(string: FirebaseManager.manager.currentUser.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: UIScreen.screenWidth * 0.6, maxHeight: UIScreen.screenHeight * 0.25)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                    .shadow(radius: 4)
                    .padding(.bottom, 60)
                
                    VStack {
                        HStack {
                            Text("Username")
                                .padding()
                                .foregroundColor(Color.white)
                            Spacer()
                        }
                        
                        HStack {
                            Text(FirebaseManager.manager.currentUser.username)
                                .padding()
                                .foregroundColor(Color.white)
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Text("Edit")
                                    .padding(5)
                                    .foregroundColor(Color.white)
                            }
                            .padding(.horizontal, 10)
                        }
                        
                        HStack {
                            Text("Email")
                                .padding()
                                .foregroundColor(Color.white)
                            Spacer()
                        }
                        
                        HStack {
                            Text(FirebaseManager.manager.currentUser.email)
                                .padding()
                                .foregroundColor(Color.white)
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Text("Edit")
                                    .padding(5)
                                    .foregroundColor(Color.white)
                            }
                            .padding(.horizontal, 10)
                        }
                    } // VStack
                    .frame(minWidth: UIScreen.screenWidth * 0.5, maxWidth: UIScreen.screenWidth * 0.8)
                    .foregroundColor(Color.white)
                    .background(RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3))
            } // VStack
            .padding(.bottom, UIScreen.screenHeight * 0.15)
            .padding(.top, 50)
        } // ZStack
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        .background(Color.green.edgesIgnoringSafeArea(.all))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
