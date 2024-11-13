//
//  Switcher.swift
//  WeCare
//
//  Created by mac on 01/10/18.
//  Copyright © 2018 Technorizen. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift

class Switcher {

    static func updateRootVC() {
        
if USER_DEFAULT.value(forKey: USERID) != nil {
        let vc = Mainboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let rightViewController1 = Mainboard.instantiateViewController(withIdentifier: "LeftSlideMenuVC") as! LeftSlideMenuVC
        let navigation = UINavigationController.init(rootViewController: vc)
        let slideMenuController = SlideMenuController.init(mainViewController: navigation, leftMenuViewController: rightViewController1)
//        navigation.isNavigationBarHidden = true
        APP_DELEGATE.window?.rootViewController = slideMenuController
        APP_DELEGATE.window?.makeKeyAndVisible()
    } else {
        let rightViewController1 = Mainboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let navigation = UINavigationController.init(rootViewController: rightViewController1)
        APP_DELEGATE.window?.rootViewController = navigation
        APP_DELEGATE.window?.makeKeyAndVisible()
    }
    }
    

}
