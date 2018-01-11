//
//  AppDelegate.swift
//  GoMaps
//
//  Created by Admin on 13/12/2017.
//  Copyright © 2017 globiaTechnologies. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreData
import GoogleSignIn
import Firebase

@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var loadedEnoughToDeepLink : Bool = false
    var deepLink : RemoteNotificationDeepLink?
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if url.host == nil
        {
            return true;
        }
        
        let urlString = url.absoluteString
        let queryArray = urlString.components(separatedBy: "/")
        let query = queryArray[2]
        
        // Check if article
        if query.range(of: "article") != nil
        {
            let data = urlString.components(separatedBy: "/")
            print(data)
            if data.count >= 3
            {
                let parameter = data[3]
                let userInfo = [RemoteNotificationDeepLinkAppSectionKey : parameter ]
                self.applicationHandleRemoteNotification(application: application, didReceiveRemoteNotification: userInfo as [NSObject : AnyObject])
            }
        }
        
        return true
    }
    
    func applicationHandleRemoteNotification(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        if application.applicationState == UIApplicationState.background || application.applicationState == UIApplicationState.inactive
        {
            let canDoNow = loadedEnoughToDeepLink
            
            self.deepLink = RemoteNotificationDeepLink.create(userInfo: userInfo)
            
            if canDoNow
            {
                triggerDeepLinkIfPresent()
            }
        }
    }
    
    func triggerDeepLinkIfPresent() -> Bool
    {
        self.loadedEnoughToDeepLink = true
        let ret = (self.deepLink?.trigger() != nil)
        self.deepLink = nil
        return ret
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       GMSServices.provideAPIKey("AIzaSyDzQaMWzObCZO5XB-oDBstNtK5oD2Hsn7c")
       GMSPlacesClient.provideAPIKey("AIzaSyDzQaMWzObCZO5XB-oDBstNtK5oD2Hsn7c")
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
       
        
        
        let selectedColor   = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        let unselectedColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)
        return true
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: [:])
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
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "GoMaps")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

