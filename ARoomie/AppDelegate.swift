//
//  AppDelegate.swift
//  ARoomie
//
//  Created by Yong Ching on 14/12/2016.
//  Copyright © 2016 Yong Ching. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import DropDown
import GoogleMaps
import GooglePlaces
import UserNotifications
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Push Notification
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        // Google Map API
        GMSServices.provideAPIKey("AIzaSyDVM2x25xBAoXcxQtJIXn-rfBrxYqzBUpw")
        GMSPlacesClient.provideAPIKey("AIzaSyDVM2x25xBAoXcxQtJIXn-rfBrxYqzBUpw")
        
        // DropDown
        DropDown.startListeningToKeyboard()
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
            annotation: nil
        )
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Push Notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "device_token")
        APIManager.shared.updateDeviceToken(token: token, completionHandler: { json in
            
            if json != nil {
                print("Stored or updated device_token")
            } else {
                print("Device_token not stored")
            }
        })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("DidFailToRegister")
        print(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        switch application.applicationState {
            
        // app is currently active, can update badges count here
        case .active:
            break
            
        // app is transitioning from background to foreground (user taps the notification)
        // do what you need when user taps here
        case .inactive:
            let data = JSON(data)
            let advertisementId = data["advertisementId"].intValue
            NotificationCenter.default.post(name: Notification.Name(rawValue: "notification"), object: advertisementId)
        
        // app is in background, if content-avaialble key is set to 1, poll to your backend to retrieve data
        // and update your interface here
        case .background:
            break
        }
    }
}

