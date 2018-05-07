//
//  AppDelegate.swift
//  On The Map
//
//  Created by Tony Buckner on 12/27/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var registered: Int = 0
    var key: String = ""
    
    var userName: String = ""
    var passWord: String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

}

