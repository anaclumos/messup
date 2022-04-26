//
//  LinkedInProfileModel.swift
//  MessUp
//
//  Created by Sunghyun Cho on 4/23/22.
//

import Foundation

struct LinkedInProfileModel: Codable {
  let firstName, lastName: StName
  let profilePicture: ProfilePicture
  let id: String
}

struct StName: Codable {
  let localized: Localized
}

struct Localized: Codable {
  let enUS: String

  enum CodingKeys: String, CodingKey {
    case enUS = "en_US"
  }
}

struct ProfilePicture: Codable {
  let displayImage: DisplayImage

  enum CodingKeys: String, CodingKey {
    case displayImage = "displayImage~"
  }
}

struct DisplayImage: Codable {
  let elements: [ProfilePicElement]
}

struct ProfilePicElement: Codable {
  let identifiers: [ProfilePicIdentifier]
}

struct ProfilePicIdentifier: Codable {
  let identifier: String
}
