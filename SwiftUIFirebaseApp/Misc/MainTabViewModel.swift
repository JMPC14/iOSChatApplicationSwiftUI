//
//  MainTabViewModel.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 07/10/2020.
//

import Foundation
import Introspect

final class MainTabViewModel: ObservableObject {
    
    var tabBarController: UITabBarController?
    
    init() {
        startListeningNotifications()
    }
    
    func startListeningNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(showTabbarView), name: NSNotification.Name("showBottomTabbar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideTabbarView), name: NSNotification.Name("hideBottomTabbar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableTabbarTouch), name: NSNotification.Name("enableTouchTabbar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disableTabbarTouch), name: NSNotification.Name("disableTouchTabbar"), object: nil)
    }
    
    @objc func showTabbarView() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func hideTabbarView() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func disableTabbarTouch() {
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
    }
    
    @objc func enableTabbarTouch() {
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
