//
//  FavoritesCoordinator.swift
//  Navigation
//
//  Created by Админ on 15.04.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class FavoritesCoordinator: FlowCoordinatorProtocol {
    
    var navigationController: UINavigationController
    weak var mainCoordinator: AppCoordinator?

    init(navigationController: UINavigationController, mainCoordinator: AppCoordinator?) {
        self.navigationController = navigationController
        self.mainCoordinator = mainCoordinator
    }

    func start() {
        let vc = FavoritesViewController()
        vc.flowCoordinator = self
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func backtoRoot() {
        guard navigationController.viewControllers.count > 0 else { return }

        navigationController.popToRootViewController(animated: true)
    }
}
