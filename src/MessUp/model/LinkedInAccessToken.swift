//
//  LinkedInAccessToken.swift
//  MessUp
//
//  Created by Sunghyun Cho on 4/24/22.
//

import Foundation

class LinkedInAccessToken: Codable {
  let accessToken: String
  let expiresIn: Int
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case expiresIn = "expires_in"
  }

  init(json: [String: Any]) {
    self.accessToken = json["access_token"] as! String
    self.expiresIn = json["expires_in"] as! Int
  }
}