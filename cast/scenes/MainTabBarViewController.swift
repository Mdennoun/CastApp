//
//  MainTabBarViewController.swift
//  cast
//
//  Created by Mohamed dennoun on 16/03/2020.
//  Copyright © 2020 DENNOUN Mohamed. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
            super.viewDidLoad()
        
            tabBar.barTintColor = UIColor.groupTableViewBackground
            setupTabBar()
           }

    let controllers = [createTabBarItem(tabBarTitle: "Home", tabBarImage: "home", viewController: HomeViewController()),
                        createTabBarItem(tabBarTitle: "Application", tabBarImage: "app", viewController: ParamViewController())]
        
    func setupTabBar() {
            
            
        viewControllers = controllers
            
            guard let items = tabBar.items else { return }
            
            for item in items {
                if (item.title == "Home") {
                    item.image = UIImage(named: "home")
                    //item.imageInsets = UIEdgeInsets(top: 10, left: 0,bottom: 10, right: 0)
                   
        } else if (item.title == "Application") {
                    
                    item.image = UIImage(named: "app")
                    item.imageInsets = UIEdgeInsets(top: 5, left: 0,bottom: 5, right: 0)
                    
                    
                } 
                viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
                
            }
        }
    
     }

     func createTabBarItem(tabBarTitle: String, tabBarImage: String, viewController: UIViewController) -> UIViewController {
        
         viewController.tabBarItem.title = tabBarTitle
         viewController.tabBarItem.selectedImage = UIImage(named: tabBarImage)
         viewController.tabBarItem.badgeColor = .red
        
         return viewController
     }
