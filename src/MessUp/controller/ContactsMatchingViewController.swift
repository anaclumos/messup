//
//  ContactsMatchingViewController.swift
//  MessUp
//
//  Created by Sunghyun Cho on 5/1/22.
//

import CoreData
import Foundation
import Kingfisher
import UIKit

class ContactsMatchingTableViewCell: UITableViewCell {
  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var usernameLabel: UILabel!
}

class ContactsMatchingViewController: UITableViewController {
  private let twitterApiManager = TwitterApiManager.shared
  private let model = AccessTokenModel.shared
  private let contactsModel = ContactsModel.shared
  var username: String = ""
  @IBOutlet var usernameButton: UIBarButtonItem!

  override func viewDidLoad() {
    username = model.getMyUsername()
    super.viewDidLoad()
    if username != "" {
      usernameButton.title = username
    } else {
      usernameButton.title = "Username"
    }
    refresh()
  }

  @IBAction func refreshButtonDidTapped(_ sender: Any) {
    refresh()
  }

  func refresh() {
    if !isValid(username: username) {
      return
    }

    twitterApiManager.getMyTwitterData { response in

      guard let data = response["data"] as? [String: Any] else {
        self.promptError(error: "Could not get data from response")
        return
      }

      guard let id = data["id"] as? String else {
        self.promptError(error: "Could not get id from data")
        return
      }

      self.twitterApiManager.getUserFollowers(userId: id) { response in
        guard let data = response["data"] as? [[String: Any]] else {
          self.promptError(error: "data field is not a dictionary")
          return
        }
        var contacts: [ContactOrm] = []
        for contact in data {
          guard let id = contact["id"] as? String else {
            self.promptError(error: "id field is not a string")
            return
          }
          guard let name = contact["name"] as? String else {
            self.promptError(error: "name field is not a string")
            return
          }
          guard let username = contact["username"] as? String else {
            self.promptError(error: "username field is not a string")
            return
          }
          guard let profileImageUrl = contact["profile_image_url"] as? String else {
            self.promptError(error: "profile_image_url field is not a string")
            return
          }
          print(profileImageUrl)
          let newContact = ContactOrm(id: id, name: name, profileImageUrl: profileImageUrl, username: username)
          contacts.append(newContact)
        }
        self.contactsModel.set(contacts: contacts)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.tableView.reloadData()
        }
      }
    }
  }

  @IBAction func usernameButtonDidTapped(_ sender: Any) {
    getUsernameInput(message: "Username must be alphanumeric between 1 and 15 characters")
  }

  func getUsernameInput(message: String) {
    let alert = UIAlertController(title: "Enter your Twitter Username", message: message, preferredStyle: .alert)
    alert.addTextField { textField in
      if self.username != "" {
        textField.text = self.username
      } else {
        textField.placeholder = "Twitter Username"
      }
    }
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
      _ in

      if self.isValid(username: alert.textFields![0].text!) {
        self.username = alert.textFields![0].text ?? ""
        self.model.setMyUsername(username: self.username)
        if self.username != "" {
          self.usernameButton.title = self.username
        } else {
          self.usernameButton.title = "Username"
        }

      } else {
        self.promptError(error: "Invalid username")
      }

      DispatchQueue.main.async {
        self.refresh()
      }
    }))
    present(alert, animated: true, completion: nil)
    if username != "" {
      usernameButton.title = username
    } else {
      usernameButton.title = "Username"
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contactsModel.getCount()
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsMatchingTableViewCell", for: indexPath) as! ContactsMatchingTableViewCell
    let contact = contactsModel.get(index: indexPath.row)
    cell.nameLabel?.text = contact.getName()
    cell.usernameLabel?.text = contact.getUsername()
    let profileImageUrl = contact.getProfileImageUrl().replacingOccurrences(of: "_normal", with: "")
    cell.profileImageView?.kf.setImage(with: URL(string: profileImageUrl))
    return cell
  }

  func promptError(error: String) {
    let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }

  func isValid(username: String) -> Bool {
    if username.count > 15 || username.count < 1 {
      getUsernameInput(message: "Username must be alphanumeric between 1 and 15 characters")
      return false
    }
    if username.range(of: "^[A-Za-z0-9_]{1,15}$", options: .regularExpression) == nil {
      getUsernameInput(message: "Username must be alphanumeric between 1 and 15 characters")
      return false
    }
    return true
  }
}
