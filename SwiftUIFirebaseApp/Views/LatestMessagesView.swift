//
//  LatestMessagesView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 02/10/2020.
//

import SwiftUI

struct LatestMessagesView: View {
    
    @State var latestMessageList = [ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid"),
                                    ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid"),
                                    ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid"),
                                    ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid"),
                                    ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid"),
                                    ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid"),
                                    ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid"),
                                    ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid"),
                                    ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid"),
                                    ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid"),
                                    ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid"),
                                    ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid"),
                                    ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid"),
                                    ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid"),
                                    ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid"),
                                    ChatMessage(fromID: "testfromid", messageId: "testid", text: "testtext", time: 100, timestamp: "testtimestamp", toID: "testtoid")]
    
    var body: some View {
        NavigationView {
            List(latestMessageList) { test in
                HStack {
                    // Profile picture
                    Image("Dog Placeholder")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(maxWidth: 60, maxHeight: 60)
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        .shadow(radius: 10)
                        
                    VStack(alignment: .leading) {
                        // Top text
                        Text(test.fromID)
                            .fontWeight(.semibold)
                            .padding(.bottom, 1)
                        
                        // Bottom text
                        Text(test.text)
                    } // VStack
                    .padding(.leading, 5)
                } //HStack
                .frame(maxHeight: 120)
            } // List
            .navigationBarTitle("Latest Messages")
        } // NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LatestMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        LatestMessagesView()
            .previewDevice("iPhone 11 Pro Max")
    }
}
