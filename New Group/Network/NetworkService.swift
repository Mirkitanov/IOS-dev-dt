//
//  NetworkService.swift
//  Navigation
//
//  Created by Админ on 28.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import Foundation

struct NetworkService {
    static func startDataTask(with url: URL, completion: ((Result<(HTTPURLResponse, Data), Error>) -> Void)? = nil) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion?(.failure(error))
                return
            }
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200,
                  
                  let data = data else {
                completion?(.failure(NetworkError.badResponse))
                return
            }
            
            completion?(.success((httpURLResponse, data)))
            
        }.resume()
    }
}

