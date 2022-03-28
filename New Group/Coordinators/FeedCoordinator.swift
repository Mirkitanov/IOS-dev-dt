//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Админ on 17.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

class FeedCoordinator: FlowCoordinatorProtocol {
    
    var navigationController: UINavigationController
    
    lazy var postPresenter = PostPresenter(self)
    
    weak var mainCoordinator: AppCoordinator?
    
    init(navigationController: UINavigationController, mainCoordinator: AppCoordinator?) {
        self.navigationController = navigationController
        self.mainCoordinator = mainCoordinator
    }
    
    func start() {
        
        let feedVC = MainFeedViewController(output: postPresenter)
        
        navigationController.pushViewController(feedVC, animated: true)
    }
    
    func backtoRoot() {
        guard navigationController.viewControllers.count > 0 else { return }
        navigationController.popToRootViewController(animated: true)
    }
    
    func gotoPost(_ post: PostOld) {
        let vc = MainPostsViewController()
        vc.flowCoordinator = self
        vc.post = post
        navigationController.pushViewController(vc, animated: true)
    }
    
    func gotoInfo(){
        let vc = MainInfoViewController()
        vc.flowCoordinator = self
        vc.cancelFinalAction = nil
        vc.deleteFinalAction = { [weak self] in
            self?.backtoRoot()
        }
        navigationController.present(vc, animated: true)
    }
}
