//
//  TwitterApiManager.swift
//  MessUp
//
//  Created by Sunghyun Cho on 5/2/22.
//

import Foundation

class TwitterApiManager {
  private let model = AccessTokenModel.shared

  static let shared = TwitterApiManager()

  public let APP_BEARER_TOKEN = TwitterCredentials.APP_BEARER_TOKEN

  init() {
  }

  func getMyTwitterData(completion: @escaping ([String: Any]) -> Void) {
    let url = URL(string: "https://api.twitter.com/2/users/me")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(model.getTwitterAccessToken()!)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    print(request)
    URLSession.shared.dataTask(with: request) { data, _, error in
      if error != nil {
        return
      }
      if let data = data {
        do {
          let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
          print(json)
          completion(json)
        } catch {
          print("getMyTwitterData Error: \(error)")
        }
      }
    }.resume()
  }

  func getUserFollowers(userId: String, completion: @escaping ([String: Any]) -> Void) {
    let url = URL(string: "https://api.twitter.com/2/users/\(userId)/followers?user.fields=profile_image_url")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(APP_BEARER_TOKEN)", forHTTPHeaderField: "Authorization")
    print("request: \(request)")
    print("request header: \(String(describing: request.allHTTPHeaderFields))")
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
      guard let data = data, error == nil else {
        print(error?.localizedDescription ?? "No data")
        return
      }
      let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
      if let responseJSON = responseJSON as? [String: Any] {
        completion(responseJSON)
      }
    }
    task.resume()
  }
}
