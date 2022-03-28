//
//  MainCoordinatorProtocol.swift
//  Navigation
//
//  Created by Админ on 17.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

protocol MainCoordinatorProtocol {
    var tabBarController: UITabBarController { get set }
    var flowCoordinators: [FlowCoordinatorProtocol] { get set }

    func start()
}
