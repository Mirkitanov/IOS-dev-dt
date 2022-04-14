//
//  JsonModels.swift
//  Navigation
//
//  Created by Админ on 13.04.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

let session = URLSession.shared

/// JSON Model for Task 1

struct JsonModelFirst {
    let userIdentifier: Int?
    let identificator: Int?
    let postTitle: String?
    let checking: Bool?
    
}

/// JSON Model for Task 2

struct JsonModelSecond: Decodable {
    
    let name: String?
    let rotation: String?
    let orbital: String?
    let diameter: String?
    let climate: String?
    let gravity: String?
    let terrain: String?
    let surfaceWater: String?
    let population: String?
    let residence: [String]?
    let films: [String]?
    let created: String?
    let updated: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case rotation = "rotation_period"
        case orbital = "orbital_period"
        case diameter = "diameter"
        case climate = "climate"
        case gravity = "gravity"
        case terrain = "terrain"
        case surfaceWater = "surface_water"
        case population = "population"
        case residence = "residents"
        case films = "films"
        case created = "created"
        case updated = "edited"
        case url = "url"
    }
}
