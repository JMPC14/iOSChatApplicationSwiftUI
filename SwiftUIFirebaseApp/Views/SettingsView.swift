//
//  SettingsView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 07/10/2020.
//

import SwiftUI
import Firebase
import UIKit

struct SettingsView: View {
    
    var body: some View {
        List {
            NavigationLink(destination: BlocklistView()) {
                Text("Blocked Users")
                
                /* Bugged: https://stackoverflow.com/questions/63945077/swiftui-multiple-navigationlinks-in-form-sheet-entry-stays-highlighted
                 https://stackoverflow.com/questions/63934037/swiftui-navigationlink-cell-in-a-form-stays-highlighted-after-detail-pop */
            }
            
            HStack {
                Text("Sign Out")
                    .foregroundColor(Color.red)
                Spacer()
            }
            .onTapGesture {
                do { try Auth.auth().signOut() }
                catch { print("sign out failed") }
                Database.database().reference(withPath: "online-users/\(FirebaseManager.manager.currentUser.uid)").setValue(false)
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct BlocklistView: View {
    var body: some View {
        List {
            Text("Test")
        }
        .navigationBarTitle("Blocked Users")
    }
}
