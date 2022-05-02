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

  private let model = AccessTokenModel.shared

  override func viewDidLoad() {
    super.viewDidLoad()
    if model.isLoggedIn() {
      DispatchQueue.main.async {
          let controller = self.storyboard?.instantiateViewController(withIdentifier: "MessUpTabBarController") as! UITabBarController
          controller.modalPresentationStyle = .fullScreen
          self.present(controller, animated: true, completion: nil)
        }
    }
  }

  @IBAction func LinkedInLoginButtonDidPress(_ sender: Any) {
    print("LinkedIn Login Button Pressed")
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? TwitterLoginWebViewController {
      vc.onAccessTokenAcquired = {
        DispatchQueue.main.async {
          let controller = self.storyboard?.instantiateViewController(withIdentifier: "MessUpTabBarController") as! UITabBarController
          controller.modalPresentationStyle = .fullScreen
          self.present(controller, animated: true, completion: nil)
        }
      }
    }
  }
}
