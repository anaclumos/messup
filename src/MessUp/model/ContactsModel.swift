//
//  ContactsModel.swift
//  MessUp
//
//  Created by Sunghyun Cho on 5/3/22.
//

import Amplitude
import Foundation

class ContactsModel {
  var contacts: [ContactOrm] = []

  static let shared = ContactsModel()

  init() {}

  func set(contacts: [ContactOrm]) {
    self.contacts = contacts
  }

  func getCount() -> Int {
    return contacts.count
  }

  func get(index: Int) -> ContactOrm {
    return contacts[index]
  }

  func filter(keyword: String) -> [ContactOrm] {
    let filteredContacts = contacts.filter {
      $0.name.lowercased().contains(keyword.lowercased()) || $0.username.lowercased().contains(keyword.lowercased())
    }
    return filteredContacts
  }
}
