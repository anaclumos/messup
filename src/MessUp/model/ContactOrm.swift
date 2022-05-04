//
//  Contacts.swift
//  MessUp
//
//  Created by Sunghyun Cho on 5/3/22.
//

import Amplitude
import Foundation

class ContactOrm {
  var id: String
  var name: String
  var profileImageUrl: String
  var username: String

  init(id: String, name: String, profileImageUrl: String, username: String) {
    self.id = id
    self.name = name
    self.profileImageUrl = profileImageUrl
    self.username = username
  }

  func getId() -> String {
    return id
  }

  func getName() -> String {
    return name
  }

  func getProfileImageUrl() -> String {
    return profileImageUrl
  }

  func getUsername() -> String {
    return username
  }
}
