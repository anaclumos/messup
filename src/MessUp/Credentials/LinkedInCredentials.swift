//
//  LinkedInCredentials.swift
//  Messup
//
//  Created by Sunghyun Cho on 4/23/22.
//

import Foundation

struct LinkedInCredentials {
  static let CLIENT_ID = ProcessInfo.processInfo.environment["LINKEDIN_CLIENT_ID"]!
  static let CLIENT_SECRET = ProcessInfo.processInfo.environment["LINKEDIN_CLIENT_SECRET"]!
  static let REDIRECT_URI = "http://localhost:8080/oauth/linkedin"
  static let SCOPE = "r_basicprofile r_emailaddress"
  static let AUTH_URL = "https://www.linkedin.com/oauth2/authorization"
  static let TOKEN_URL = "https://www.linkedin.com/oauth2/accessToken"
}
