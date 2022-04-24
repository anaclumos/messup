//
//  LinkedInLoginViewController.swift
//  MessUp
//
//  Created by Sunghyun Cho on 4/24/22.
//

import Foundation
import WebKit

class LinkedInLoginViewController: UIViewController, WKNavigationDelegate {
  @IBOutlet var spinner: UIActivityIndicatorView!
  @IBOutlet var LinkedInLoginView: WKWebView!
  @IBAction func cancelButtonDidPress(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    LinkedInLoginView.navigationDelegate = self
    requestAuthCode()
  }

  // Request an Authorization Code
  func requestAuthCode() {
    // GET https://www.linkedin.com/oauth/v2/authorization
    // Parameter	    Type      Description
    // response_type	string	  The value of this field should always be: code
    // client_id	    string	  The API Key value generated when you registered your application.
    // redirect_uri	  url	The   URI your users are sent back to after authorization. This value must match one of the Redirect URLs defined in your application configuration. For example, https://dev.example.com/auth/linkedin/callback.
    // scope	        string	  URL-encoded, space-delimited list of member permissions your application is requesting on behalf of the user. These must be explicitly requested. For example, scope=r_liteprofile%20r_emailaddress%20w_member_social. See Permissions and Best Practices for Application Development for additional information.
    var components = URLComponents()
    components.scheme = "https"
    components.host = LinkedInCredentials.HOST_URL
    components.path = LinkedInCredentials.AUTH_PATH
    components.queryItems = [
      URLQueryItem(name: "response_type", value: "code"),
      URLQueryItem(name: "client_id", value: LinkedInCredentials.CLIENT_ID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),
      URLQueryItem(name: "scope", value: LinkedInCredentials.SCOPE.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),
      URLQueryItem(name: "redirect_uri", value: LinkedInCredentials.REDIRECT_URI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
    ]
    let request = URLRequest(url: components.url!)
    print("requestAuthCode: \(request)")
    LinkedInLoginView.load(request)
  }

  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    spinner.isHidden = false
    spinner.startAnimating()
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    spinner.stopAnimating()
    spinner.isHidden = true
  }
}
