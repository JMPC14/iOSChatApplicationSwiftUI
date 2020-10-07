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
            
            NavigationLink(destination: EmptyView()) {
                Text("Sign Out")
                    .foregroundColor(Color.red)
                    .onTapGesture {
                        do { try Auth.auth().signOut() }
                        catch { print("sign out failed") }
                        UserDefaults.standard.set(false, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    }
            }
            .padding(.trailing, -32.0)
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
