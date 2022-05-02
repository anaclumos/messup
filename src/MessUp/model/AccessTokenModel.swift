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

  func isLoggedIn() -> Bool {
    return twitterAccessToken != nil
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
      token.setValue(expires_in, forKeyPath: "expires_in")
      token.setValue(scope, forKeyPath: "scope")

      do {
        try managedContext.save()
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
  }
}
