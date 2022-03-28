//
//  AppDelegate.swift
//  Navigation
//
//  Created by Artem Novichkov on 12.09.2020.
//  Copyright © 2020 Artem Novichkov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appConfiguration: AppConfiguration?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appConfiguration = AppConfiguration.random()
        getData()
        
        return true
    }
    
    
    private func getData() {
        guard let appConfiguration = appConfiguration,
              let apiUrl = URL(string: appConfiguration.rawValue) else {
            return
        }
        
        print("Getting data from \(apiUrl)")
                
        NetworkService.startDataTask(with: apiUrl) { result in

            switch result {
            case .failure(let error):
                // In case of no Internet
                // Code=-1009 "The Internet connection appears to be offline."
                print(error.localizedDescription)

            case .success(let (response, data)):
                print("Received data:")
                if let humanReadable = data.prettyJson { print(humanReadable) }
                print("Status code: \(response.statusCode)")
                print("All header fields:")
                response.allHeaderFields.forEach { print("    \($0): \($1)") }
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

