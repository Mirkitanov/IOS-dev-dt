//
//  JsonParsing.swift
//  Navigation
//
//  Created by Админ on 13.04.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

struct JsonParsing {

    /// Переменная для передачи значения на вьюконтроллер
    static var textForLabel: String?

    /// Функция парсинга для первой задачи
    static func parsingFirstTask(url: URL, completion: @escaping (Data?) -> Void)->  Void {
        
        let taskOne = session.dataTask(with: url) {
            data, response, error in
                
            guard error == nil else {
                    print(error.debugDescription)
                    return
                }
                
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print(error.debugDescription)
                return
            }
                
            guard let data = data else {
                print(error.debugDescription)
                return
            }
                
            if let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String,Any> {
                
                let model = JsonModelFirst (
                    userIdentifier: dictionary["userId"] as? Int,
                    identificator: dictionary["id"] as? Int,
                    postTitle: dictionary["title"] as? String,
                    checking: dictionary["completed"] as? Bool)

                textForLabel = model.postTitle
            }
        }
        taskOne.resume()
    }
    
    ///Переменная для второй задачи
    static var orbital: String?
    
    /// Функция парсинга для второй задачи
    static func parsingSecondTask(url: URL, completion: @escaping (Data?) -> Void) -> Void{
        
        let taskTwo =
            session.dataTask(with: url) {data, response, error in
                
                guard error == nil else {
                        print(error.debugDescription)
                        return
                    }
                    
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    print(error.debugDescription)
                    return
                }
                    
                guard let data = data else {
                    print(error.debugDescription)
                    return
                }
                
            if let model = try? JSONDecoder().decode(JsonModelSecond.self, from: data){
                orbital = model.orbital
                
            DispatchQueue.main.async {
                completion(data) }
            }
        }
        taskTwo.resume()
    }
}

