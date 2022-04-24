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
    // alert
    let alert = UIAlertController(title: "LinkedIn Login", message: "Please login with your LinkedIn account", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}
