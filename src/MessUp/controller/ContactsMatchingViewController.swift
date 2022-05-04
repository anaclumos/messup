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

  @IBAction func refreshButtonDidTapped(_ sender: Any) {
    print("button tapped")
    print(model.getTwitterAccessToken() as Any)
    self.twitterApiManager.getMyTwitterData { response in

      // try decoding data field as MyUserdata

      guard let data = response["data"] as? [String: Any] else {
        print("data field is not a dictionary")
        return
      }

      guard let id = data["id"] as? String else {
        print("id field is not a string")
        return
      }

      guard let name = data["name"] as? String else {
        print("name field is not a string")
        return
      }

      guard let username = data["username"] as? String else {
        print("username field is not a string")
        return
      }

      let myUserdata = MyUserdata(id: id, name: name, username: username)

      self.twitterApiManager.getUserFollowers(userId: id) { response in
        print(response)
      }
    }
  }

  @IBAction func usernameButtonDidTapped(_ sender: Any) {
    var username = self.model.getMyUsername()

    let alert = UIAlertController(title: "Enter your Twitter Username", message: nil, preferredStyle: .alert)
    alert.addTextField { textField in
      if username != "" {
        textField.text = username
      } else {
        textField.placeholder = "Twitter Username"
      }
    }
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
      _ in
      username = alert.textFields![0].text ?? ""
      self.model.setMyUsername(username: username)
    }))
    present(alert, animated: true, completion: nil)
  }
}
