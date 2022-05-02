//
//  TwitterLoginViewController.swift
//  MessUp
//
//  Created by Sunghyun Cho on 5/1/22.
//

import Foundation
import WebKit

class TwitterLoginWebViewController: UIViewController, WKNavigationDelegate {
  private let model = AccessTokenModel.shared
  var onAccessTokenAcquired: (() -> Void)?
  @IBOutlet var spinner: UIActivityIndicatorView!
  @IBOutlet var TwitterLoginView: WKWebView!
  @IBAction func cancelButtonDidPress(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    TwitterLoginView.navigationDelegate = self

    if model.getTwitterAccessToken() != nil {
      onAccessTokenAcquired?()
    } else {
    getRequestToken()
    }

  }

  private func getRequestToken() {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "twitter.com"
    components.path = "/i/oauth2/authorize"
    components.queryItems = [
      URLQueryItem(name: "response_type", value: TwitterCredentials.RESPONSE_TYPE),
      URLQueryItem(name: "client_id", value: TwitterCredentials.CLIENT_ID),
      URLQueryItem(name: "redirect_uri", value: TwitterCredentials.REDIRECT_URI),
      URLQueryItem(name: "scope", value: TwitterCredentials.SCOPE),
      URLQueryItem(name: "state", value: TwitterCredentials.STATE),
      URLQueryItem(name: "code_challenge", value: TwitterCredentials.CODE_CHALLENGE),
      URLQueryItem(name: "code_challenge_method", value: TwitterCredentials.CODE_CHALLENGE_METHOD)
    ]
    let request = URLRequest(url: components.url!)
    print("getRequestTokenCode: \(request)")
    TwitterLoginView.load(request)
  }

  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    print("webView:decidePolicyFor: \(navigationAction)")
    // print current URL
    print("current URL: \(String(describing: webView.url))")
    if let url = navigationAction.request.url {
      if url.absoluteString.hasPrefix(TwitterCredentials.REDIRECT_URI) {
        if let code = url.absoluteString.components(separatedBy: "code=").last {
          print("code: \(code)")
          getAccessToken(code: code)
          dismiss(animated: true, completion: nil)
        }
      }
    }
    decisionHandler(.allow)
  }
  
  func getAccessToken(code: String) {
      var components = URLComponents()
      components.scheme = "https"
      components.host = "api.twitter.com"
      components.path = "/2/oauth2/token"
      components.queryItems = [
        URLQueryItem(name: "code", value: code.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),
        URLQueryItem(name: "grant_type", value: "authorization_code"),
        URLQueryItem(name: "client_id", value: TwitterCredentials.CLIENT_ID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),
        URLQueryItem(name: "redirect_uri", value: TwitterCredentials.REDIRECT_URI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),
        URLQueryItem(name: "code_verifier", value: TwitterCredentials.CODE_VERIFIER.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
      ]
      // use POST method
      var request = URLRequest(url: components.url!)
      request.httpMethod = "POST"
      request.allHTTPHeaderFields = [
        "Content-Type": "application/x-www-form-urlencoded"
      ]

      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        if error != nil {
          return
        }
        if let data = data {
          do {
            print("data loaded!: \(String(data: data, encoding: .utf8)!)")

            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

            self.model.setTwitterAccessToken(json: json)
            self.onAccessTokenAcquired?()
          } catch {
            print("requestAccessToken Error: \(error)")
          }
        }
      }
      task.resume()
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
