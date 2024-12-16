//
//  AppDelegate.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/14/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = MainViewController()
        return true
    }
}

