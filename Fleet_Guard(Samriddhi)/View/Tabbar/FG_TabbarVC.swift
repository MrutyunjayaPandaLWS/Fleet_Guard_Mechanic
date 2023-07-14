//
//  FG_TabbarVc.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 18/01/2023.
//

import UIKit
import LanguageManager_iOS

class FG_TabbarVc: UITabBarController {

    
    var comingFrom = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        if self.comingFrom == "DelegateData"{
//            _ = self.tabBarController?.selectedIndex = 1
//        }
        tabBarController?.tabBar.items![0].title = "My_Ledger".localiz()
        tabBarController?.tabBar.items![1].title = "Home".localiz()
        tabBarController?.tabBar.items![2].title = "My_redemption".localiz()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if self.selectedIndex == 0 {
            self.tabBarController?.selectedIndex = selectedIndex
        }else if self.selectedIndex == 1{
            let rootView = self.viewControllers![self.selectedIndex] as! UINavigationController
            rootView.popToRootViewController(animated: false)
        }else if self.selectedIndex == 2{
            self.tabBarController?.selectedIndex = selectedIndex
        }
    }

}
struct Constants{
    static var tabbarVC : FG_TabbarVc!
}
