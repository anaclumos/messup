//
//  ContactsMatchingViewController.swift
//  MessUp
//
//  Created by Sunghyun Cho on 5/1/22.
//

import Foundation
import UIKit

class ContactsMatchingViewController: UITableViewController {
  private let twitterApiManager = TwitterApiManager.shared
  @IBAction func refreshButtonDidTapped(_ sender: Any) {
    print("button tapped")
    twitterApiManager.getMyTwitterData { response in
      print(response)
      self.twitterApiManager.getUserFollowers(userId: response["id"] as! String) { json in
        print(json)
      }
    }
  }
}
