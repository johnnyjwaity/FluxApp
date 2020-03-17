//
//  AppDelegate.swift
//  Flux
//
//  Created by Johnny Waity on 3/31/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit
import KeychainAccess
import SCSDKLoginKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    static var hasAttemptedRegistrantion:Bool = false
    static var deviceToken:String? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
//        UNUserNotificationCenter.current().delegate = self
        let tabController = UITabBarController()
        let layout = UICollectionViewFlowLayout()
        let homeController = HomeController(collectionViewLayout: layout)
        homeController.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "home").withRenderingMode(.alwaysTemplate), tag: 0)
        homeController.title = "Home"
        let searchController = SearchController()
        searchController.tabBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate), tag: 1)
        searchController.title = "Search"
        let postController = PostController()
        postController.title = "Post"
        postController.tabBarItem = UITabBarItem(title: "Post", image: #imageLiteral(resourceName: "send").withRenderingMode(.alwaysTemplate), tag: 2)
        let profileController = ProfileController()
        ProfileController.myProfile = profileController
        profileController.title = "Profile"
        profileController.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "profile").withRenderingMode(.alwaysTemplate), tag: 3)
        tabController.viewControllers = [UINavigationController(rootViewController: homeController), UINavigationController(rootViewController: searchController), UINavigationController(rootViewController: postController), UINavigationController(rootViewController: profileController)]
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()
        
        
        let keychain = Keychain(service: "com.johnnywaity.flux")
        if let refresh = keychain["refresh"] {
            Network.request(url: "https://api.tryflux.app/getNewToken", type: .post, paramters: ["refreshToken": refresh]) { (response, error) in
                if let s = response["success"] as? Bool {
                    if s {
                        Network.authToken = (response["token"]! as! String)
                        homeController.getFeed()
                    }
                    else{
                        tabController.present(LoginController(), animated: true, completion: nil)
                    }
                }else{
                    tabController.present(LoginController(), animated: true, completion: nil)
                }
            }
        }else{
            tabController.present(LoginController(), animated: true, completion: nil)
        }
        return true
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("HELLO")
        let handled = SCSDKLoginClient.application(app, open: url, options: options)
        return handled
    }
    
    static func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                 granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                AppDelegate.getNotificationSettings()
        }
    }
    
    static func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        AppDelegate.deviceToken = token
        Network.request(url: "https://api.tryflux.app/deviceToken", type: .post, paramters: ["deviceToken" : token], auth: true)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

