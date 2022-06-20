//
//  MapCordinator.swift
//  Navigation
//
//  Created by Админ on 15.06.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//


import UIKit
import CoreLocation

class MapCoordinator: FlowCoordinatorProtocol {
    
    var navigationController: UINavigationController
    weak var mainCoordinator: AppCoordinator?

    init(navigationController: UINavigationController, mainCoordinator: AppCoordinator?) {
        self.navigationController = navigationController
        self.mainCoordinator = mainCoordinator
    }

    func start() {
        let locationManager = CLLocationManager()
        let locationService = LocationService(locationManager: locationManager)
        let vc = MapViewController(locationService: locationService)
        vc.flowCoordinator = self
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func backtoRoot() {
        guard navigationController.viewControllers.count > 0 else { return }

        navigationController.popToRootViewController(animated: true)
    }
    
//    func gotoProfile() {
//        let vc = MainProfileViewController()
//        vc.flowCoordinator = self
//        
//        navigationController.navigationBar.isHidden = true
//        navigationController.pushViewController(vc, animated: true)
//    }
//
//    func gotoPhotos() {
//        let vc = PhotosViewController()
//        vc.flowCoordinator = self
//        
//        navigationController.pushViewController(vc, animated: true)
//        
//    }
}
