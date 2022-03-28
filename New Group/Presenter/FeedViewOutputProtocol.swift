//
//  FeedViewOutputProtocol.swift
//  Navigation
//
//  Created by Админ on 24.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit
protocol FeedViewOutputProtocol {
    var flowCoordinator: FeedCoordinator { get set }
    
    func showPost(_ post: PostOld)
}
