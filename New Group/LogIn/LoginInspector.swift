//
//  LoginInspector.swift
//  Navigation
//
//  Created by Админ on 13.12.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
class LoginInspector: LoginViewControllerDelegate {
    
    /// Function of login checking
    func checkLogin(_ login: String) -> Bool {
        let loginMatching = Checker.shared.checkingLogin(login: login)
        return loginMatching
    }
    
    /// Function of password checking
    func checkPassword(_ password: String) -> Bool {
        let passwordMatching = Checker.shared.checkingPassword(password: password)
        return passwordMatching
    }
}
