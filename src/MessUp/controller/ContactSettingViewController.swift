//
//  ContactSettingViewController.swift
//  MessUp
//
//  Created by Sunghyun Cho on 5/3/22.
//

import Amplitude
import Contacts
import ContactsUI
import Foundation
import Kingfisher
import UIKit

class ContactSettingViewController: UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate {
  @IBOutlet var profileView: UIImageView!
  @IBOutlet var visitTwitterButton: UIButton!
  @IBOutlet var navigationBar: UINavigationItem!

  var onComplete: (() -> Void)?

  @IBAction func cancelButtonDidTapped(_ sender: Any) {
    Amplitude.instance().logEvent("Cancel Button Did Tapped")
    dismiss(animated: true, completion: nil)
    onComplete?()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    onComplete?()
  }

  var imageUrl: String!
  var username: String!
  var name: String!

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBar.title = name
    profileView.layer.cornerRadius = profileView.frame.width / 2
    profileView.layer.masksToBounds = true
    let image = imageUrl.replacingOccurrences(of: "_normal", with: "")
    profileView.kf.setImage(with: URL(string: image))
    if username != nil {
      print("Visit @" + username!)
      visitTwitterButton.setTitle("Visit @" + username!, for: .normal)
    } else {
      visitTwitterButton.isHidden = true
    }
  }

  @IBAction func visitTwitterButtonDidTapped(_ sender: Any) {
    Amplitude.instance().logEvent("Visit Twitter Button Did Tapped")
    if username == nil {
      return
    }
    guard let url = URL(string: "https://twitter.com/\(username ?? "")") else {
      return
    }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }

  @IBAction func setToContactsButtonDidTapped(_ sender: Any) {
    Amplitude.instance().logEvent("Set to Contacts Button Did Tapped")
    let store = CNContactStore()
    store.requestAccess(for: .contacts) { granted, _ in
      if granted {
        self.updateContacts(image: self.profileView.image!)
      } else {
        self.promptError(error: "Could not get access to contacts")
      }
    }
  }

  // MARK: - Creates a new contact and adds it to the user's contacts.
  func updateContacts(image: UIImage) {
    DispatchQueue.main.async {
      Amplitude.instance().logEvent("Updated Contacts")

      // Create a new contact
      let contact = CNMutableContact()

      // set contact image
      contact.imageData = image.jpegData(compressionQuality: 1.0)

      // set contact social
      let twitter = CNSocialProfile(urlString: "https://twitter.com/\(self.username ?? "")", username: self.username, userIdentifier: nil, service: CNSocialProfileServiceTwitter)
      let social: CNLabeledValue<CNSocialProfile> = CNLabeledValue(label: "Twitter", value: twitter)
      contact.socialProfiles.append(social)

      // set view controller
      let saveVC = CNContactViewController(forUnknownContact: contact)
      saveVC.contactStore = CNContactStore()
      saveVC.delegate = self

      // set bar button item
      let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelButtonDidTapped(_:)))
      saveVC.navigationItem.leftBarButtonItem = cancelButton

      // present view controller
      saveVC.modalPresentationStyle = .formSheet
      let navigationController = UINavigationController(rootViewController: saveVC)
      self.present(navigationController, animated: true, completion: nil)
    }
  }

  // MARK: - Prompts Error
  func promptError(error: String) {
    Amplitude.instance().logEvent("Error: \(error)")
    let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }

  // MARK: - Prompts Success Message
  func promptSuccess() {
    let alert = UIAlertController(title: "Success", message: "Contact saved", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}
