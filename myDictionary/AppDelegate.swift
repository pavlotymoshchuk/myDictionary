//
//  AppDelegate.swift
//  myDictionary
//
//  Created by Павло Тимощук on 20.01.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON
import UserNotifications

class Words
{
    var word: String = ""
    var translate: [String] = []
    var studied: Bool = false
}
var wordsArray: [Words] = []

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound])
        {
            (granted, error) in
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>){}

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer =
    {
        let container = NSPersistentCloudKitContainer(name: "myDictionary")
        container.loadPersistentStores(completionHandler:
        { (storeDescription, error) in
            if let error = error as NSError?
            {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext ()
    {
        let context = persistentContainer.viewContext
        if context.hasChanges
        {
            do
            {
                try context.save()
            }
            catch
            {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

