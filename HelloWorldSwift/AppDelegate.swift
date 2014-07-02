//
//  AppDelegate.swift
//  HelloWorldSwift
//
//  Created by Corinne Krych on 12/06/14.
//  Copyright (c) 2014 aerogear. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    /** TODO on UPS sender
    { "aps" : {
        "alert": "you're invited",
        "category": "HelloWorld"
        }
    }
    **/
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary) -> Bool {
        // Override point for customization after application launch.
        let category = registerAction()
        var categories = NSMutableSet()
        categories.addObject(category)
        let settings = UIUserNotificationSettings(forTypes: .Alert | .Badge, categories:categories)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()

        return true
    }
    
    func registerAction() -> UIMutableUserNotificationCategory {
        let action1 = UIMutableUserNotificationAction()
        action1.identifier = "Accept"
        action1.title = "Accept"
        action1.activationMode = .Background
        action1.destructive = false
        action1.authenticationRequired = false
        
        let action2 = UIMutableUserNotificationAction()
        action2.identifier = "Trash"
        action2.title = "Trash"
        action2.activationMode = .Background
        action2.destructive = true
        action2.authenticationRequired = true
        
        let action3 = UIMutableUserNotificationAction()
        action3.identifier = "Reply"
        action3.title = "Reply"
        action3.activationMode = .Foreground
        action3.destructive = false
        action3.authenticationRequired = false
        
        let category = UIMutableUserNotificationCategory()
        category.identifier = "HelloWorld"
        category.setActions([action1, action2, action3], forContext: .Default)
        category.setActions([action1, action3], forContext: .Minimal)
        return category
        
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication!, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!) {
        NSLog("APN Success")
        let registration = AGDeviceRegistration(serverURL: NSURL(string: "<# URL of the running AeroGear UnifiedPush Server #>"))
        
        registration.registerWithClientInfo({ (clientInfo: AGClientDeviceInformation!) -> () in
            NSLog("UPS Register")
            clientInfo.deviceToken = deviceToken
            clientInfo.variantID = "<# Variant Id #>"
            clientInfo.variantSecret = "<# Variant Secret #>"
            
                // apply the token, to identify THIS device
                let currentDevice = UIDevice()
            
                // --optional config--
                // set some 'useful' hardware information params
                clientInfo.operatingSystem = currentDevice.systemName
                clientInfo.osVersion = currentDevice.systemVersion
                clientInfo.deviceType = currentDevice.model
            }, success: { () -> () in
                NSLog("UPS Success Register")
                // Send NSNotification for success_registered, will be handle by registered AGViewController
                let notification = NSNotification(name:"success_registered", object: nil)
                NSNotificationCenter.defaultCenter().postNotification(notification)
                
            }, failure: { (error:NSError!) -> () in
                NSLog("UPS Error Register")
                let notification = NSNotification(name:"error_register", object: nil)
                NSNotificationCenter.defaultCenter().postNotification(notification)
            })
    }
    
    func application(application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError!) {
        NSLog("ERROR")
    }
    
    func application(application: UIApplication!, didReceiveRemoteNotification userInfo: NSDictionary!) {
        // When a message is received, send NSNotification, will be handle by registered AGViewController
        let notification = NSNotification(name:"message_received", object:userInfo)
        NSNotificationCenter.defaultCenter().postNotification(notification)
        NSLog("UPS message received: %@", userInfo);
    }
    
    func application(application: UIApplication!, didReceiveLocalNotification userInfo: NSDictionary!) {
         NSLog("Local message received: %@", userInfo);
        var msg =  NSMutableDictionary(dictionary: ["aps":["alert":"Ping..opened"]])
        
        let notification = NSNotification(name:"message_received", object:msg)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    func application(application: UIApplication!, handleActionWithIdentifier identifier: String!, forLocalNotification notification: UILocalNotification!, completionHandler: (() -> Void)!) {
        if(identifier == "Accept") {
            
            var msg =  NSMutableDictionary(dictionary: ["aps":["alert":notification.alertBody+"..accepted"]])

            let notification = NSNotification(name:"message_received", object:msg)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        } else if(identifier == "Trash") {
            var msg =  NSMutableDictionary(dictionary: ["aps":["alert":notification.alertBody+"..trashed"]])
            
            let notification = NSNotification(name:"message_received", object:msg)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        
        } else if(identifier == "Reply") {
        
        }
        completionHandler()
    }

}

