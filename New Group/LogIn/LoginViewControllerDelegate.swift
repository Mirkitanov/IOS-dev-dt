//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Админ on 19.04.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
protocol LoginViewControllerDelegate: AnyObject {
    func creteUser(id: String, login: String?, password: String?, failure: @escaping (Errors) -> Void) -> Bool
    func checkUsers() -> [User]
    func setCurrentUser (id: String)
    func resetCurrentUser (id: String)
}
