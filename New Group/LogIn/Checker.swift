//
//  Checker.swift
//  Navigation
//
//  Created by Админ on 13.12.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation

/// Class for login and password checking
class Checker {
    private let loginFromCheker = "Pavel"
    private let passwordFromCheker = "123"
    
    static let shared: Checker = {
        let checker = Checker()
        return checker
    }()
    
    //MARK: - Init
    private init() {}
    
    /// Function of login checking
    func checkingLogin(login: String) -> Bool {
        guard login.hash == self.loginFromCheker.hash else {
            print ("Логин: Данные не верны")
            return false
        }
        
        print ("Логин: Данные верны")
        return true
    }
    
    /// Function of password checking
    func checkingPassword(password: String) -> Bool {
        guard password.hash == self.passwordFromCheker.hash else {
            print ("Пароль: Данные не верны")
            return false
        }
        
        print ("Пароль: Данные верны")
        return true
    }
}

