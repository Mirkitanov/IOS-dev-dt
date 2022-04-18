//
//  LoginInspector.swift
//  Navigation
//
//  Created by Админ on 13.12.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class CachedUser: Object {
    dynamic var id: String?
    dynamic var login: String?
    dynamic var password: String?
    dynamic var isCurrentUser: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class LoginInspector: LoginViewControllerDelegate {
    
    private var realm: Realm? {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("users.realm")
        return try? Realm(configuration: config)
    }
    
    func checkUsers() -> [User] {
        return realm?.objects(CachedUser.self).compactMap {
            guard let id = $0.id, let login = $0.login, let password = $0.password
            else { return nil }
            return User(id: id, login: login, password: password, isCurrentUser: $0.isCurrentUser  )
        } ?? []
    }
    
    func creteUser(id: String, login: String?, password: String?, failure: @escaping (Errors) -> Void) -> Bool {
        
        if login == "" && password == ""  {
            
            failure(.noData)
            return false
            
        } else if login == nil || login == "" {
            
            failure(.incorrectEmail)
            return false
            
        } else if password == nil || password == "" {
            
            failure(.incorrectData)
            return false
            
        } else if password!.count < 6 {
            
            failure(.shortPassword)
            return false
            
        } else {
            
            let user = CachedUser()
            user.id = id
            user.login = login
            user.password = password
            user.isCurrentUser = true
            
            try? realm?.write {
                realm?.add(user)
            }
            return true
        }
    }
    
    func setCurrentUser (id: String){

        guard let user = realm?.object(ofType: CachedUser.self, forPrimaryKey: id ) else {
            return
        }

        try? realm?.write({
            user.isCurrentUser = true
            print("Curent user is fixed")
        })
    }
    
    func resetCurrentUser (id: String){

        guard let user = realm?.object(ofType: CachedUser.self, forPrimaryKey: id ) else {
            return
        }

        try? realm?.write({
            user.isCurrentUser = false
            print("Curent user is reset")
        })
    }
}
