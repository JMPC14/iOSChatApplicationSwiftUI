//
//  ChatView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 05/10/2020.
//

import SwiftUI

struct ChatView: View {
    
    @State var messagesArray = [ChatMessage]()
    @State var writing = ""
    
    var body: some View {
        VStack {
            List(messagesArray) { message in
                HStack {
                    Text("Test")
                }
            }
            
            HStack {
                TextField("Enter a message...", text: self.$writing)
                    .padding(10)
                    .background(Color(red: 233.0/255, green: 234.0/255, blue: 243.0/255))
                    .cornerRadius(25)
                
                Button(action: {
                    
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 30, weight: .ultraLight))
                }
                
            }
            .padding(.horizontal, 10)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
