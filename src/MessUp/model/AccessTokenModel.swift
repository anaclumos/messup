//
//  LinkedInAccessTokenModel.swift
//  MessUp
//
//  Created by Sunghyun Cho on 4/24/22.
//

import Amplitude
import CoreData
import Foundation
import UIKit

class AccessTokenModel {
  var twitterAccessToken: TwitterAccessToken?

  static let shared = AccessTokenModel()

  init() {
    refresh()
  }

  func refresh() {
    // fetch from core data
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
    else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TwitterAccessToken")
    do {
      twitterAccessToken = try managedContext.fetch(fetchRequest).first as? TwitterAccessToken
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  func getTwitterAccessToken() -> TwitterAccessToken? {
    return twitterAccessToken
  }

  func getMyUsername() -> String {
    return twitterAccessToken?.my_username ?? ""
  }

  func setMyUsername(username: String) {
    refresh()
    print("trying to save \(username)")
    if twitterAccessToken == nil {
      print("twitterAccessToken is nil")
      return
    }
    twitterAccessToken!.my_username = username
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
    else {
      print("no appDelegate")
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    do {
      // save twitterAccessToken to CoreData
      try managedContext.save()
      print("saved")
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    print("saved username. username is now \(String(describing: twitterAccessToken?.my_username))")
  }

  func isLoggedIn() -> Bool {
    if twitterAccessToken == nil {
      return false
    }
    if twitterAccessToken?.access_token == nil {
      return false
    }
    if twitterAccessToken?.expiry_date == nil {
      return false
    }
    let now = Date()
    if now > (twitterAccessToken?.expiry_date)! {
      return false
    }
    return true
  }

  func setTwitterAccessToken(json: [String: Any]) {
    DispatchQueue.main.async {
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate
      else {
        return
      }
      let access_token = json["access_token"] as? String
      let token_type = json["token_type"] as? String
      let expires_in = json["expires_in"] as? Int
      let expiry_date = Date(timeIntervalSinceNow: TimeInterval(expires_in!))
      let scope = json["scope"] as? String

      let managedContext =
        appDelegate.persistentContainer.viewContext

      let entity =
        NSEntityDescription.entity(forEntityName: "TwitterAccessToken",
                                   in: managedContext)!

      let token = NSManagedObject(entity: entity,
                                  insertInto: managedContext)

      token.setValue(access_token, forKeyPath: "access_token")
      token.setValue(token_type, forKeyPath: "token_type")
      token.setValue(expiry_date, forKeyPath: "expiry_date")
      token.setValue(expires_in, forKeyPath: "expires_in")
      token.setValue(scope, forKeyPath: "scope")
      token.setValue("", forKeyPath: "my_username")
      print(token)
      do {
        try managedContext.save()
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
  }

  func logoutTwitter() {
    DispatchQueue.main.async {
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate
      else {
        return
      }

      let managedContext =
        appDelegate.persistentContainer.viewContext

      let fetchRequest =
        NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterAccessToken")

      let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

      do {
        try managedContext.execute(deleteRequest)
      } catch let error as NSError {
        print("Could not delete. \(error), \(error.userInfo)")
      }
    }
    twitterAccessToken = nil
  }
}
