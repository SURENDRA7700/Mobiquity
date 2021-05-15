//
//  ViewController.swift
//  Mobiquity
//
//  Created by surendra on 14/05/21.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let navHome = HomeVC()
        let homeTab = UINavigationController(rootViewController: navHome)
        homeTab.tabBarItem.image = UIImage(named: "hometab")?.withRenderingMode(.alwaysTemplate)
        homeTab.title = "Home"
        
//        let cityVC = CityVC()
//        let cityTab = UINavigationController(rootViewController: cityVC)
//        cityTab.tabBarItem.image = UIImage(named: "cityTab")?.withRenderingMode(.alwaysTemplate)
//        cityTab.title = "City"

        let helpVC = HelpVC()
        let helptab = UINavigationController(rootViewController: helpVC)
        helptab.tabBarItem.image = UIImage(named: "helpTab")?.withRenderingMode(.alwaysTemplate)
        helptab.title = "Help"

        self.tabBar.tintColor = UIColor.ketoGenik.Blue
        self.tabBar.unselectedItemTintColor = UIColor.ketoGenik.Black
        viewControllers = [homeTab, helptab]
       

    }


}

