//
//  MoreTableViewController.swift
//  MessUp
//
//  Created by Sunghyun Cho on 5/2/22.
//

import Foundation
import UIKit

class MoreTableViewController: UITableViewController {
  private let model = AccessTokenModel.shared
  @IBAction func resetTokenDidTapped(_ sender: Any) {
    self.model.logoutTwitter()
    let controller = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
    controller.modalPresentationStyle = .fullScreen
    self.present(controller, animated: true, completion: nil)
  }
}
