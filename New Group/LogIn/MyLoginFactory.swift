//
//  MyLoginFactory.swift
//  Navigation
//
//  Created by Админ on 13.12.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation

class MyLoginFactory: LoginFactoryProtocol {
    
    func createLoginInspector() -> LoginInspector {
        
        let loginInspectorObject = LoginInspector()
        
        return loginInspectorObject
    }
}
