//
//  NetworkError.swift
//  Navigation
//
//  Created by Админ on 28.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case badResponse
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Данный URL не является валидным"
        case .badResponse:
            return "Не получен валидный ответ от сервера"
        case .invalidData:
            return "Не удалось распознать ответ от сервера"
        }
    }
}
