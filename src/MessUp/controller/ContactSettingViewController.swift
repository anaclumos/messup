//
//  ContactSettingViewController.swift
//  MessUp
//
//  Created by Sunghyun Cho on 5/3/22.
//

import Foundation
import Kingfisher
import UIKit

class ContactSettingViewController: UIViewController {
  @IBOutlet var profileView: UIImageView!
  @IBOutlet var visitTwitterButton: UIButton!

  var imageUrl: String!
  var username: String!

  override func viewDidLoad() {
    super.viewDidLoad()
    profileView.layer.cornerRadius = profileView.frame.width / 10
    profileView.layer.masksToBounds = true
    visitTwitterButton.layer.cornerRadius = 5
    visitTwitterButton.layer.masksToBounds = true
    let image = imageUrl.replacingOccurrences(of: "_normal", with: "")
    profileView.kf.setImage(with: URL(string: image))
  }

  @IBAction func visitTwitterButtonDidTapped(_ sender: Any) {
    guard let url = URL(string: "https://twitter.com/\(String(describing: username))") else {
      return
    }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }

  @IBAction func setToContactsButtonDidTapped(_ sender: Any) {
    // alert
    let alert = UIAlertController(title: "Set to Contacts", message: "Do you want to set \(String(describing: username)) to your contacts?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
      _ in
      // save to contacts
      print("trying to save \(String(describing: self.username))")
    }))
  }
}
