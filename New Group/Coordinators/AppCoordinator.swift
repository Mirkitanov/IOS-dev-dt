//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Админ on 17.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class AppCoordinator: MainCoordinatorProtocol {
    /// Feed tab bar navigation
    lazy var feedNavigationController: UINavigationController = {
        var navigationController = UINavigationController()
        let title = "Feed"
        let image = UIImage(systemName: "house.fill")
        navigationController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image)
        return navigationController
    }()
    /// Profile tab bar navigation
    lazy var profileNavigationController: UINavigationController = {
        var navigationController = UINavigationController()
        let title = "Profile"
        let image = UIImage(systemName: "person.fill")
        navigationController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image)
        return navigationController
    }()
    
    var tabBarController: UITabBarController
    var flowCoordinators = [FlowCoordinatorProtocol]()

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    func start() {
        flowCoordinators = [
            FeedCoordinator(navigationController: feedNavigationController, mainCoordinator: self),
            ProfileCoordinator(navigationController: profileNavigationController, mainCoordinator: self)
        ]
        
        for coordinator in flowCoordinators {
            coordinator.start()
        }
        
        // Add tab bars controllers
        tabBarController.viewControllers = [feedNavigationController, profileNavigationController]
    }
}
