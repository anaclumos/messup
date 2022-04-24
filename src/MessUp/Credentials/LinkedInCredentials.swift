//
//  LinkedInCredentials.swift
//  MessUp
//
//  Created by Sunghyun Cho on 4/23/22.
//

import Foundation

struct LinkedInCredentials {
  static let CLIENT_ID = ProcessInfo.processInfo.environment["LINKEDIN_CLIENT_ID"]!
  static let CLIENT_SECRET = ProcessInfo.processInfo.environment["LINKEDIN_CLIENT_SECRET"]!
  static let REDIRECT_URI = "http://localhost:8080/oauth/linkedin"
  static let SCOPE = "r_liteprofile"
  static let HOST_URL = "www.linkedin.com"
  static let AUTH_PATH = "/oauth/v2/authorization"
  static let TOKEN_PATH = "/oauth/v2/accessToken"
}
