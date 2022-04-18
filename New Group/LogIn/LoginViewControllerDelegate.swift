//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Админ on 19.04.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
protocol LoginViewControllerDelegate: AnyObject {
    /// Function of login checking
    func checkLogin(_ login: String) -> Bool
    /// Function of password checking
    func checkPassword(_ password: String) -> Bool
}
