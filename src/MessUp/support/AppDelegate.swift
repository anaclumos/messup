//
//  AppDelegate.swift
//  MessUp
//
//  Created by Sunghyun Cho on 4/20/22.
//

import Amplitude
import CoreData
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Enable sending automatic session events
    Amplitude.instance().trackingSessionEvents = true
    // Initialize SDK
    Amplitude.instance().initializeApiKey("b9cf3af08fa8c103b9582f1fccecf55e")
    // Set userId
    Amplitude.instance().setUserId("userId")
    // Log an event
    Amplitude.instance().logEvent("app_start")

    return true
  }

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "MessUpDataModel")
    container.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Unable to load persistent stores: \(error)")
      }
    }
    return container
  }()

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
}
