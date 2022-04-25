//
//  LinkedInAccessTokenModel.swift
//  MessUp
//
//  Created by Sunghyun Cho on 4/24/22.
//

import Foundation

class AccessTokenModel: Codable {
  var linkedinAccessToken : LinkedInAccessToken? = nil

  // singleton
  static let shared = AccessTokenModel()

  init() {
  }

  func getLinkedInAccessToken() -> LinkedInAccessToken? {
    return linkedinAccessToken
  }

  func setLinkedInAccessToken(linkedinAccessToken: LinkedInAccessToken) {
    self.linkedinAccessToken = linkedinAccessToken
  }
}
