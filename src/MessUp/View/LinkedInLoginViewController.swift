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

  func requestAuthCode() {
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

  func requestAccessToken(code: String) {
    print("requestAccessToken: \(code)")
    var components = URLComponents()
    components.scheme = "https"
    components.host = LinkedInCredentials.HOST_URL
    components.path = LinkedInCredentials.TOKEN_PATH
    components.queryItems = [
      URLQueryItem(name: "grant_type", value: "authorization_code"),
      URLQueryItem(name: "code", value: code.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),
      URLQueryItem(name: "client_id", value: LinkedInCredentials.CLIENT_ID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),
      URLQueryItem(name: "client_secret", value: LinkedInCredentials.CLIENT_SECRET.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),
      URLQueryItem(name: "redirect_uri", value: LinkedInCredentials.REDIRECT_URI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
    ]
    DispatchQueue.main.async {
      self.spinner.startAnimating()
      URLSession.shared.dataTask(with: components.url!) { data, _, error in
        if let error = error {
          print("requestAccessToken: \(error)")
          return
        }
        if let data = data {
          do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print("requestAccessToken: \(json)")
            if let json = json as? [String: Any] {
              if let accessToken = json["access_token"] as? String {
                print("requestAccessToken: \(accessToken)")
              }
            }
          } catch {
            print("requestAccessToken: \(error)")
          }
        }
      }
    }
  }

  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if let url = navigationAction.request.url {
      if url.absoluteString.hasPrefix(LinkedInCredentials.REDIRECT_URI) {
        if let code = url.absoluteString.components(separatedBy: "code=").last {
          DispatchQueue.main.async {
            self.requestAccessToken(code: code)
            self.dismiss(animated: true, completion: nil)
          }
        }
      }
    }
    decisionHandler(.allow)
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
