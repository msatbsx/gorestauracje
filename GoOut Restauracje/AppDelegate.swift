//
//  AppDelegate.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 18/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import UserNotifications
import BRYXBanner

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate {
    
    var window: UIWindow?
    let googleMapsApiKey = "xxx"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        window!.backgroundColor = UIColor(patternImage:UIImage(named: "background")!)
        let realm = try! Realm()
        try! realm.write({
            realm.deleteAll()
        })
        GMSServices.provideAPIKey(googleMapsApiKey)
        FIRApp.configure()
        registerToken(userToken:FIRInstanceID.instanceID().token())
        
        if #available(iOS 10.0, *) {
            
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // Override point for customization after application launch.
        
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        checkMessagesData()
        
        
        //load messages view after recived notification
        if (launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification]) != nil
        {
            AppManager.sharedInstance.forceOpenMessagesView = true
        }

        return true
    }
    
    func checkMessagesData()
    {
        RestClient.sharedInstance.getUserMessages { (messArray, success) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ConstantsStruct.Notifications.kNotificationMessagesChecked), object: nil)
        }
    }
    
    func hasRegisteredToken() -> Bool
    {
        if (UserDefaults.standard.object(forKey: "userNotificationToken") != nil)
        {
            if UserDefaults.standard.object(forKey: "userNotificationToken") as! String != ""
            {
                return true
            }
            
        }
        return false
    }
    
    func registerToken(userToken:String?)
    {
        if !hasRegisteredToken()
        {
            if let tok = userToken
            {
                if tok.characters.count > 0
                {
                    RestClient.sharedInstance.registerUsertokenForNotifications(token: tok, completion: { (success) in
                        if success
                        {
                            UserDefaults.standard.set(tok, forKey: "userNotificationToken")
                        }
                    })
                    
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.unknown)
        FIRMessaging.messaging().subscribe(toTopic: "/topics/globalStart")
    }
    
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if(application.applicationState == UIApplicationState.background)
                {
                    AppManager.sharedInstance.forceOpenMessagesView = true
                }
        if SYSTEM_VERSION_LESS_THAN(version: "10.0")
        {
            var notificationTittle = "GoOut Restauracje"
            var notificationBody = ""
            
            if let aps = userInfo["aps"] as? NSDictionary
            {
                if let alert = aps["alert"] as? NSDictionary
                {
                    if let message = alert["body"] as? NSString
                    {
                        notificationBody = message as String
                    }
                    if let title = alert["title"] as? NSString
                    {
                        notificationTittle = title as String
                    }
                    
                }
                else if let alert = aps["alert"] as? NSString
                {
                    notificationBody = alert as String
                }
            }
            
            let banner = Banner(title: notificationTittle, subtitle: notificationBody, image: UIImage(named: "Appicon"), backgroundColor: ConstantsStruct.Colors.backgroundColor)
            banner.dismissesOnTap = true
            banner.show(duration: 3.0)
            
            print("Showing banner from ios 9   %@", userInfo)
            
            print("")
            
        }
        
    }

    func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool
    {
        
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }
    
    // [END receive_message]
    
    // [START refresh_token]
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    
    // [START connect_to_fcm]
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
                self.registerToken(userToken:FIRInstanceID.instanceID().token())
            }
        }
    }
    // [END connect_to_fcm]
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        connectToFcm()
    }
    
    
    // [START disconnect_from_fcm]
    func applicationDidEnterBackground(_ application: UIApplication) {
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }
    // [END disconnect_from_fcm]
    //}
    
    // [START ios_10_message_handling]
    @available(iOS 10, *)
    //extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        var notificationTittle = "GoOut Restauracje"
        var notificationBody = ""
        
         print("showing banner ios 10  %@", userInfo as NSDictionary)
        
        if let aps = userInfo["aps"] as? NSDictionary
        {
            if let alert = aps["alert"] as? NSDictionary
            {
                if let message = alert["body"] as? NSString
                {
                    notificationBody = message as String
                }
                if let title = alert["title"] as? NSString
                {
                    notificationTittle = title as String
                }
            }
            else if let alert = aps["alert"] as? NSString
            {
                notificationBody = alert as String
            }
        }
        let banner = Banner(title: notificationTittle, subtitle: notificationBody, image: UIImage(named: "Appicon"), backgroundColor: ConstantsStruct.Colors.backgroundColor)
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
        
//        print("showing banner ios 10  %@", userInfo as NSDictionary)
        
    }
    
    // Receive data message on iOS 10 devices.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
                
    }
   
    func applicationWillResignActive(_ application: UIApplication)
    {

        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    //    func applicationDidEnterBackground(_ application: UIApplication)
    //    {
    //        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    //        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    //    func applicationDidBecomeActive(_ application: UIApplication)
    //    {
    //        NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: ConstantsStruct.Notifications.kNotifApplicationBecomeActive), object: nil)
    //
    //    }
    
    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //    @available(iOS 10.0, *)
    //    func userNotificationCenter(_ center: UNUserNotificationCenter,
    //                                willPresent notification: UNNotification,
    //                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    //        let userInfo = notification.request.content.userInfo
    //        // Print message ID.
    //        print("Message ID: \(userInfo["gcm.message_id"]!)")
    //        
    //        // Print full message.
    //        print("%@", userInfo)
    //    }
    
    
}
