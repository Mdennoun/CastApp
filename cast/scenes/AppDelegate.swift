//
//  AppDelegate.swift
//  cast
//
//  Created by DENNOUN Mohamed on 10/03/2020.
//  Copyright © 2020 DENNOUN Mohamed. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
  
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          
        // Override point for customization after application launch.
        
        let homeViewController = MainTabBarViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        let w = UIWindow(frame: UIScreen.main.bounds)
        w.rootViewController = navigationController
        w.makeKeyAndVisible()
        self.window = w
             
        return true
    }


}

