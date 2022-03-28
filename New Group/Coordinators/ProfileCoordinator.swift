//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Админ on 17.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class ProfileCoordinator: FlowCoordinatorProtocol {
    
    var navigationController: UINavigationController
    weak var mainCoordinator: AppCoordinator?

    init(navigationController: UINavigationController, mainCoordinator: AppCoordinator?) {
        self.navigationController = navigationController
        self.mainCoordinator = mainCoordinator
    }

    func start() {
        let vc = MainLogInViewController()
        vc.flowCoordinator = self
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func backtoRoot() {
        guard navigationController.viewControllers.count > 0 else { return }

        navigationController.popToRootViewController(animated: true)
    }
    
    func gotoProfile() {
        let vc = MainProfileViewController()
        vc.flowCoordinator = self
        
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }

    func gotoPhotos() {
        let vc = PhotosViewController()
        vc.flowCoordinator = self
        
        navigationController.pushViewController(vc, animated: true)
        
    }
}
