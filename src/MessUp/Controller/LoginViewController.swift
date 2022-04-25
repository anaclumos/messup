//
//  LoginViewController.swift
//  MessUp
//
//  Created by Sunghyun Cho on 4/23/22.
//

import Foundation

import UIKit
import WebKit

class LoginViewController: UIViewController {
  @IBOutlet var LinkedInLoginButton: UIButton!
  @IBAction func LinkedInLoginButtonDidPress(_ sender: Any) {
    print("LinkedIn Login Button Pressed")
  }

  private let model = AccessTokenModel.shared

  @IBOutlet var tokenLabel: UILabel!

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? LinkedInLoginViewController {
      vc.onAccessTokenAcquired = {
        DispatchQueue.main.async {
          self.tokenLabel.text = "Access Token: " + (self.model.getLinkedInAccessToken()?.accessToken ?? "Not Provided")
        }
      }
    }
  }
}
