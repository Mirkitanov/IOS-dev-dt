//
//  PostPresenter.swift
//  Navigation
//
//  Created by Админ on 24.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit
class PostPresenter: FeedViewOutputProtocol {
    var flowCoordinator: FeedCoordinator
    
    init(_ flowCoordinator: FeedCoordinator) {
        self.flowCoordinator = flowCoordinator
    }
    
    func showPost(_ post: PostOld) {
        flowCoordinator.gotoPost(post)
    }
}

