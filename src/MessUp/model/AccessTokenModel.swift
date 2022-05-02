//
//  LinkedInAccessTokenModel.swift
//  MessUp
//
//  Created by Sunghyun Cho on 4/24/22.
//

import Foundation

class AccessTokenModel: Codable {
  var twitterAccessToken : TwitterAccessToken? = nil
  

  // singleton
  static let shared = AccessTokenModel()

  init() {
  }

  func getTwitterAccessToken() -> TwitterAccessToken? {
    return twitterAccessToken
  }

  func setTwitterAccessToken(twitterAccessToken: TwitterAccessToken) {
    self.twitterAccessToken = twitterAccessToken
    // attempt to save token
  }
}
