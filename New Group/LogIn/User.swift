//
//  User.swift
//  Navigation
//
//  Created by Админ on 15.04.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import Foundation

struct User {
    var id: String
    var login: String
    var password: String
    var isCurrentUser: Bool?
    
    init(id: String, login: String, password: String, isCurrentUser: Bool) {
        self.id = id
        self.login = login
        self.password = password
        self.isCurrentUser = isCurrentUser
    }
}
