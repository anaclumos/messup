//
//  ContactsMatchingViewController.swift
//  MessUp
//
//  Created by Sunghyun Cho on 5/1/22.
//

import Amplitude
import CoreData
import Foundation
import Kingfisher
import UIKit

class ContactsMatchingTableViewCell: UITableViewCell {
  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var usernameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
  }
}

class ContactsMatchingViewController: UITableViewController, UISearchBarDelegate {
  private let twitterApiManager = TwitterApiManager.shared
  private let model = AccessTokenModel.shared
  private let contactsModel = ContactsModel.shared

  var filteredContacts: [ContactOrm] = []

  var username: String = ""

  @IBOutlet var searchBar: UISearchBar!

  override func viewDidLoad() {
    super.viewDidLoad()
    username = model.getMyUsername()
    setUpNavigationBar()
    refresh()
    searchBar.delegate = self
    searchBar.placeholder = "Search"
    filteredContacts = contactsModel.contacts
    tableView.keyboardDismissMode = .onDrag
  }

  // This method updates filteredData based on the text in the Search Box
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      filteredContacts = contactsModel.contacts
    } else {
      filteredContacts = contactsModel.filter(keyword: searchText)
    }
    tableView.reloadData()
  }

  func setUpNavigationBar() {
    let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [
      UIAction(title: "@\(username)", image: UIImage(systemName: "person.crop.circle"), identifier: nil, handler: { _ in
        Amplitude.instance().logEvent("Username Button Did Tapped")
        self.getUsernameInput(message: "Username must be alphanumeric between 1 and 15 characters")
      }),
      UIAction(title: "Refresh", image: UIImage(systemName: "arrow.clockwise"), identifier: nil, handler: { _ in
        Amplitude.instance().logEvent("Refresh Button Did Tapped")
        self.refresh()
      }),
      UIAction(title: "Log Out", image: UIImage(systemName: "multiply.circle"), identifier: nil, handler: { _ in
        print("Log Out")
        Amplitude.instance().logEvent("Log Out Button Did Tapped")
        self.model.logoutTwitter()
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
      })
    ])
    let menuButton = UIBarButtonItem(image: UIImage(systemName: "gear"), primaryAction: nil, menu: menu)
    navigationItem.rightBarButtonItem = menuButton
  }

  @objc func refresh() {
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
          self.promptError(error: String(describing: response))
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
        self.filteredContacts = contacts
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.tableView.reloadData()
        }
      }
    }
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
      Amplitude.instance().logEvent("Alert Dismissed")
      if self.isValid(username: alert.textFields![0].text!) {
        self.username = alert.textFields![0].text ?? ""
        self.model.setMyUsername(username: self.username)
      } else {
        self.promptError(error: "Invalid username")
      }

      DispatchQueue.main.async {
        self.refresh()
        self.setUpNavigationBar()
      }
    }))
    present(alert, animated: true, completion: nil)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredContacts.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsMatchingTableViewCell", for: indexPath) as! ContactsMatchingTableViewCell
    let contact = filteredContacts[indexPath.row]
    cell.nameLabel?.text = contact.getName()
    cell.usernameLabel?.text = "@" + contact.getUsername()
    let profileImageUrl = contact.getProfileImageUrl().replacingOccurrences(of: "_normal", with: "")
    cell.profileImageView?.kf.setImage(with: URL(string: profileImageUrl))
    return cell
  }

  func promptError(error: String) {
    Amplitude.instance().logEvent("Error: \(error)")
    let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }

  // MARK: - Checks if username is valid

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

  // MARK: - Prepare for segue to ContactSettingsViewController

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "loadProfile" {
      let destination = segue.destination as! ContactSettingViewController
      let index = tableView.indexPathForSelectedRow!.row
      destination.imageUrl = filteredContacts[index].getProfileImageUrl()
      destination.username = filteredContacts[index].getUsername()
      destination.name = filteredContacts[index].getName()
      destination.onComplete = {
        if let indexPath = self.tableView.indexPathForSelectedRow {
          self.tableView.deselectRow(at: indexPath, animated: true)
        }
      }
    }
  }
}
