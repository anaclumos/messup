//
//  LoginViewController.swift
//  MessUp
//
//  Created by Sunghyun Cho on 4/23/22.
//

import Amplitude
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
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MessUpController") as! UINavigationController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
      }
    }
  }

  @IBAction func twitterLoginButton(_ sender: Any) {
    Amplitude.instance().logEvent("Twitter Login Button Did Tapped")
    print("twitterLoginButton Pressed")
  }

  // MARK: - Prepare for segue to MessUpTabBarController
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? TwitterLoginWebViewController {
      print("LoginViewController prepare for segue")
      vc.onAccessTokenAcquired = {
        DispatchQueue.main.async {
          let controller = self.storyboard?.instantiateViewController(withIdentifier: "MessUpController") as! UINavigationController
          controller.modalPresentationStyle = .fullScreen
          self.present(controller, animated: true, completion: nil)
        }
      }
    }
  }
}
