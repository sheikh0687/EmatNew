//
//  AppDelegate.swift
//  F5Places
//  Created by mac on 22/10/19.
//  Copyright © 2019 mac. All rights reserved.

import UIKit
import IQKeyboardManagerSwift
import CoreLocation
import SwiftyJSON
import UserNotifications
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate {
    
    var window: UIWindow? 
    var CURRENT_LAT = ""
    var CURRENT_LON = ""
    var isValidLocation:Bool = true
    var coordinate1 = CLLocation(latitude: 0.0, longitude: 0.0)
    var coordinate2 = CLLocation(latitude: 0.0, longitude: 0.0)
    var arr_allWorkout:[JSON]? = []
    var strCatID:String! = ""
    var strChildCatID:String! = ""
    var strRequestType:String! = ""
    var strProviderID:String! = ""
    var strTitle:String! = ""
    var strUrl:String! = ""
    var strSpeciliat:String! = ""
    var strDetail:String! = ""

    var isFromCat:Bool! = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //        Switcher.updateRootVC()
        IQKeyboardManager.shared.enable = true
        LocationManager.sharedInstance.delegate = APP_DELEGATE
        LocationManager.sharedInstance.startUpdatingLocation()
        
        
        USER_DEFAULT.setValue("en", forKey: LanguageUser)
        if USER_DEFAULT.value(forKey: USERID) != nil {
            Switcher.updateRootVC()
        }
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().delegate = self

        self.configureNotification()

        //Covid
        return true
    }
    
    func configureNotification() {
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        }
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                USER_DEFAULT.set(token, forKey: IOS_TOKEN)
                //k.iosRegisterId = token
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
     
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        // k.iosRegisterId = deviceTokenString
        Messaging.messaging().apnsToken = deviceToken
        print("APNs device token: \(deviceTokenString)")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
        
    }
    
    // MARK:-  Received Remote Notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print(userInfo)
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject> {
            print(info)
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }

//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        IOS_REGISTER_ID = deviceTokenString
//        USER_DEFAULT.set(IOS_REGISTER_ID, forKey: IOS_TOKEN)
//        print(deviceTokenString)
//    }
//
//    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
//        print(error)
//    }
//
//    // MARK:-  Received Remote Notification
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//        print(userInfo)
//
//        let state = application.applicationState
//        let visibleVC = UIApplication.topViewController()!
//
//        var key:String! = ""
//
//        if let booking_stas = (userInfo["aps"] as! NSDictionary)["booking_status"] as? String {
//            key = booking_stas
//        } else {
//            if let key7 = (userInfo["aps"] as! NSDictionary)["key"] as? String {
//                key = key7
//
//            }
//            if let key7D = (userInfo["aps"] as! NSDictionary)["title"] as? String {
//                key = key7D
//                strDetail = key7D
//            }
//
//        }
//
//        if key == "You have a new message" {
//            if visibleVC is UserChat {
//                NotificationCenter.default.post(name: NSNotification.Name("NewMessage"), object: "On Ride", userInfo: nil)
//            } else {
//                    DispatchQueue.main.async {
//                        self.OpenNewme(dict: (userInfo["aps"] as! NSDictionary), application: application)
//                    }
//            }
//        } else {
//            redirectToAcceptRequest(strKEy: key)
//        }
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
//
    func redirectToAcceptRequest(strKEy:String) {
        
        if UIApplication.topViewController() != nil {

            let vc = UIApplication.topViewController()!

            Utility.showAlertWithAction(withTitle: APP_NAME, message: strKEy, delegate: nil, parentViewController: vc) { (res) in
                DispatchQueue.main.async { [self] in
                    let vs = kStoryboardMain.instantiateViewController(withIdentifier: "NotificationDetailVC") as! NotificationDetailVC
                    vs.isKey = strKEy
                    vs.isKeyDetail = strDetail
                    vc.navigationController?.pushViewController(vs, animated: true)
                }
            }
        }
        
    }
    
    func OpenNewme(dict:NSDictionary,application:UIApplication) {
        
        let visibleVC = UIApplication.topViewController()
        let alertController = UIAlertController(title: APPNAME, message: "You have a New Chat Message", preferredStyle: .alert)
        let yesAction: UIAlertAction = UIAlertAction(title: "Show", style: .default) { action -> Void in
                let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "UserChat") as! UserChat
                objVC.receiverId = dict["user_id"] as! String
                objVC.userName = "\(dict["first_name"] as! String) \(dict["last_name"] as! String)"
                objVC.strReason = ""
                objVC.strReasonID = ""
                visibleVC?.navigationController?.pushViewController(objVC, animated: true)
        }
        let noAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Ok")
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        visibleVC?.present(alertController, animated: true, completion: nil)
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
}
extension AppDelegate:LocationManagerDelegate {
    func tracingLocation(currentLocation: CLLocation) {
        coordinate2 = currentLocation
        let distanceInMeters = coordinate1.distance(from: coordinate2) // result is in meters
        if distanceInMeters > 250 {
            CURRENT_LAT = String(currentLocation.coordinate.latitude)
            CURRENT_LON = String(currentLocation.coordinate.longitude)
            coordinate1 = currentLocation
        }
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        
    }
    
}

//MARK:Extention

//extension AppDelegate {
//
//    //MARK:- Push notification delegate iOS9 and less
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let chars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
//        var token = ""
//        for i in 0..<deviceToken.count {
//            token += String(format: "%02.2hhx", arguments: [chars[i]])
//        }
//        print("IMNIRANJAN-\(token)")
//        kUserDefault.set(token, forKey: IOS_TOKEN)
//
//    }
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register: \(error)")
//    }
//
//    // Calling from background
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//        print(userInfo)
//        let state = application.applicationState
//        let visibleVC = UIApplication.topViewController()!
//
//        if (state == UIApplication.State.active || state == UIApplication.State.inactive)  {
//            //                let key = userInfo["key"] as! String
//            var alertMsg = ""
//
//            //                if key == "You have a new message" {
//            if visibleVC is UserChat {
//                NotificationCenter.default.post(name: NSNotification.Name("NewMessage"), object: "On Ride", userInfo: nil)
//            } else {
//                if UIApplication.topViewController() != nil {
//                    DispatchQueue.main.async {
//                        self.redirectToAcceptRequest()
//                    }}}} else {
//            if UIApplication.topViewController() != nil {
//                DispatchQueue.main.async {
//                    self.redirectToAcceptRequest()
//                }
//            }}
//
//        //        }
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
//
//    func redirectToAcceptRequest() {
//        if UIApplication.topViewController() != nil {
//            NotificationCenter.default.post(name: Notification.Name("NewMessage"), object: nil)
//            let vc = UIApplication.topViewController()!
//            Utility.showAlertWithAction(withTitle: APP_NAME, message: "You have a new message", delegate: nil, parentViewController: vc) { (res) in
//                Switcher.updateRootVC()
//            }
//        }
//    }
//
//    func registerDeviceToReceivePushNotification(_ application:UIApplication){
//        if #available(iOS 10.0, *) {
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {
//                    //_, _ in
//                    value1, value2 in
//                    print(value1)
//                    print(value2)
//            })
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
//    }
//}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        //Messaging.messaging().appDidReceiveMessage(userInfo)
        print("plx \(userInfo)")

        if let info = userInfo as? Dictionary<String, AnyObject> {
            let alert1 = info["aps"]!["alert"] as! Dictionary<String, AnyObject>
            let title = alert1["title"] as! String
            print("Notification Title: ",title)
            hanleNotification(info: info, strStatus: title, strFrom: "Front")
        }
        completionHandler([[.alert, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        if let info = userInfo as? Dictionary<String, AnyObject> {
            let alert1 = info["aps"]!["alert"] as! Dictionary<String, AnyObject>
            let title = alert1["title"] as! String
            hanleNotification(info: info, strStatus: title, strFrom: "Back")
        }
        completionHandler()
    }

    //MARK:GoViewCotroller
    
    func hanleNotification(info:Dictionary<String,AnyObject>,strStatus:String,strFrom:String) {
        
        let visibleVC = UIApplication.topViewController()
        if strStatus == "You have a new message" && strFrom == "Back" {
            if visibleVC is UserChat {
                NotificationCenter.default.post(name: NSNotification.Name("NewMessage"), object: "On Ride", userInfo: nil)
            } else {
                if UIApplication.topViewController() != nil {
                    NotificationCenter.default.post(name: Notification.Name("NewMessage"), object: nil)
                    let vc = UIApplication.topViewController()!
                    Utility.showAlertWithAction(withTitle: APP_NAME, message: "You have a new message", delegate: nil, parentViewController: vc) { (res) in
                        Switcher.updateRootVC()
                }
              }
            }
        } else if strStatus == "You have a new message" && strFrom == "Front" {
            if visibleVC is UserChat {
                NotificationCenter.default.post(name: NSNotification.Name("NewMessage"), object: "On Ride", userInfo: nil)
            } else {
                if UIApplication.topViewController() != nil {
                    NotificationCenter.default.post(name: Notification.Name("NewMessage"), object: nil)
                    let vc = UIApplication.topViewController()!
                    Utility.showAlertWithAction(withTitle: APP_NAME, message: "You have a new message", delegate: nil, parentViewController: vc) { (res) in
                        Switcher.updateRootVC()
                }
              }
            }
        }  else {
            let alert1 = info["aps"]!["alert"] as! Dictionary<String, AnyObject>
            let title = alert1["title"] as! String
            let message = alert1["message"] as! String

            redirectToAcceptRequest(strKEy: title, strKEyDe: message)
        }
//        else if strStatus == "Request Accept" || strStatus == "Request Reject" {
//              let objVC = Mainboard.instantiateViewController(withIdentifier: "MyOrderVC") as! MyOrderVC
//              visibleVC?.navigationController?.pushViewController(objVC, animated: true)
//        } else if strStatus == "New bid"  {
//            let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "ViewOfferVC") as! ViewOfferVC
//            objVC.strPrID = (info["product_id"] as? String)!.replacingOccurrences(of: " ", with: "")
//            objVC.strName = ((info["product_name"] as? String)!)
//            visibleVC?.navigationController?.pushViewController(objVC, animated: true)
//        }
        
    }
    
    
    func goChatVC() {
        let visibleVC = UIApplication.topViewController()!
        visibleVC.tabBarController?.selectedIndex = 1
        Utility.showAlertMessage(withTitle: APPNAME, message: "", delegate: nil, parentViewController: visibleVC)
    }
    
    func redirectToAcceptRequest(strKEy:String,strKEyDe:String) {
        
        if UIApplication.topViewController() != nil {

            let vc = UIApplication.topViewController()!

            Utility.showAlertWithAction(withTitle: APP_NAME, message: strKEy, delegate: nil, parentViewController: vc) { (res) in
                DispatchQueue.main.async { [self] in
                    let vs = kStoryboardMain.instantiateViewController(withIdentifier: "NotificationDetailVC") as! NotificationDetailVC
                    vs.isKey = strKEy
                    vs.isKeyDetail = strKEyDe
                    vc.navigationController?.pushViewController(vs, animated: true)
                }
            }
        }
        
    }
}
