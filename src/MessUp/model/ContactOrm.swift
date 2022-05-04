//
//  Contacts.swift
//  MessUp
//
//  Created by Sunghyun Cho on 5/3/22.
//

import Foundation

// {
//     id = 2748947849;
//     name = "Zhiyu (Apollo) Zhu \Ud83d\Udcad";
//     "profile_image_url" = "https://pbs.twimg.com/profile_images/1477496658325741572/VTUnNdkK_normal.jpg";
//     username = "zhuzhiyu_";
// }

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
