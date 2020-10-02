//
//  LatestMessageCell.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 02/10/2020.
//

import SwiftUI

struct LatestMessageCell: View {
    
    var message: ChatMessage
    
    var body: some View {
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
                Text("Test Top")
                    .fontWeight(.semibold)
                    .padding(.bottom, 1)
                
                // Bottom text
                Text("Test Bottom")
            }
            .padding(.leading, 5)
        }
        .frame(maxHeight: 120)
    }
}

//struct LatestMessageCell_Previews: PreviewProvider {
//    static var previews: some View {
//        LatestMessageCell(message: ChatMessage("testfromid", "testid", "testtext", 100, "testtimestamp", "testtoid"))
//    }
//}
