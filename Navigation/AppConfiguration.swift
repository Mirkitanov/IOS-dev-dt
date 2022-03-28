//
//  AppConfiguration.swift
//  Navigation
//
//  Created by Админ on 28.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import Foundation

enum AppConfiguration: String {
    
    case people = "http://swapi.dev/api/people/8/"
    case starships = "http://swapi.dev/api/starships/3/"
    case planets = "http://swapi.dev/api/planets/5/"
    
    
    static func random() -> AppConfiguration {
        var appConfiguration: AppConfiguration
        
        let randomItem = Int.random(in: 0...2)
        switch randomItem {
        case 0:
            appConfiguration = .people
        case 1:
            appConfiguration = .starships
        default:
            appConfiguration = .planets
        }

        return appConfiguration
    }
    
}
