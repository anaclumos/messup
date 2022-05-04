//
//  LinkedInAccessTokenModel.swift
//  MessUp
//
//  Created by Sunghyun Cho on 4/24/22.
//

import CoreData
import Foundation
import UIKit

class AccessTokenModel {
  var twitterAccessToken: TwitterAccessToken?

  static let shared = AccessTokenModel()

  init() {
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

  func setMyUsername (username: String) {
    twitterAccessToken?.my_username = username
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
    else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
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
