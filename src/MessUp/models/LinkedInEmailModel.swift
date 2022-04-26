//
//  LinkedInEmailModel.swift
//  MessUp
//
//  Created by Sunghyun Cho on 4/23/22.
//

import Foundation

struct LinkedInEmailModel: Codable {
  let elements: [Element]
}

struct Element: Codable {
  let elementHandle: Handle
  let handle: String

  enum CodingKeys: String, CodingKey {
    case elementHandle = "handle~"
    case handle
  }
}

struct Handle: Codable {
  let emailAddress: String
}
