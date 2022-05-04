//
//  ContactsMatchingViewController.swift
//  MessUp
//
//  Created by Sunghyun Cho on 5/1/22.
//

import CoreData
import Foundation
import UIKit

class ContactsMatchingViewController: UICollectionViewController {
  private let twitterApiManager = TwitterApiManager.shared
  private let model = AccessTokenModel.shared

  // // override init
  // override init(collectionViewLayout layout: UICollectionViewLayout) {
  //   super.init(collectionViewLayout: layout)
  //   DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
  //     let accessToken = self.model.getTwitterAccessToken()!
  //     let alert = UIAlertController(title: "AccessToken already exists in CoreData", message: "Token: \(String(describing: accessToken))", preferredStyle: .alert)
  //     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
  //     self.present(alert, animated: true, completion: nil)
  //   }
  // }

  // // init coder
  // required init?(coder aDecoder: NSCoder) {
  //   super.init(coder: aDecoder)
  // }

  @IBAction func refreshButtonDidTapped(_ sender: Any) {
    print("button tapped")
    self.twitterApiManager.getMyTwitterData { response in
      print(response)
      self.twitterApiManager.getUserFollowers(userId: response["id"] as! String) { json in
        print(json)
      }
    }
  }

  @IBAction func usernameButtonDidTapped(_ sender: Any) {
    // fetch from core data, look for my_username at TwitterAccessToken
    // fetch
    var username: String?

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
    else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TwitterAccessToken")
    do {
      let twitterAccessToken = try managedContext.fetch(fetchRequest).first as? TwitterAccessToken
      username = twitterAccessToken?.my_username
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    let alert = UIAlertController(title: "Enter your Twitter Username", message: nil, preferredStyle: .alert)
    alert.addTextField { textField in
      if username != nil || username != "" {
        textField.text = username
      }
      else {
        textField.placeholder = "Twitter Username"
      }
    }
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
      _ in
      username = alert.textFields?.first?.text
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
      else {
        return
      }
      let managedContext = appDelegate.persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TwitterAccessToken")
      do {
        let twitterAccessToken = try managedContext.fetch(fetchRequest).first as? TwitterAccessToken
        twitterAccessToken?.my_username = username
        try managedContext.save()
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }))
    present(alert, animated: true, completion: nil)
  }
}
