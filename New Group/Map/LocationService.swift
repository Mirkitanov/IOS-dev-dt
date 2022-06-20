//
//  LocationService.swift
//  Navigation
//
//  Created by Админ on 15.06.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    /**
     Вызывается, когда `CLLocationManager` получает обновление местоположения
     - parameters:
       - location: *местоположение Пользователя*
     */
    func received(location: CLLocationCoordinate2D)

    /**
     Вызывается, когда `CLLocationManager` не имеет необходимых разрешений для обновления местоположения Пользователя.

     - parameters:
        - permanently: Указывает, может ли пользователь изменять предоставленные разрешения

     Если статус авторизации `.restricted`, пользователь не может ничего сделать, чтобы изменить статус авторизации.
     В противном случае мы можем предложить решение
     */
    func determinedServiceUnavailable(permanently: Bool)

    /// Вызывается, когда `CLLocationManager` получает необходимые разрешения для обновления местоположения пользователя
    func determinedServiceAvailable()
}

class LocationService: NSObject {

    // MARK: - Public properties

    weak var delegate: LocationServiceDelegate?
    
    var cityName: String = ""
    
    var countryName: String = ""

    // MARK: - Private properties

    private var locationManager: CLLocationManager

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        super.init()
    }

    // MARK: - Public methods

    /// Получите необходимые разрешения и начните отслеживать местоположение
    func start() {
        self.locationManager.delegate = self
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }

        handleAuthorizationStatus(authorizationStatus)
    }

    /// Остановка отслеживания локации
    func stop() {
        locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
    }

    // MARK: - Private methods

    /// Вспомогательный метод для выбора правильного действия на основе статуса авторизации
    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,
             .authorizedWhenInUse:
            delegate?.determinedServiceAvailable()
            locationManager.startUpdatingLocation()
        case .denied:
            delegate?.determinedServiceUnavailable(permanently: false)
        case .restricted:
            delegate?.determinedServiceUnavailable(permanently: true)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthorizationStatus(status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        delegate?.received(location: location)
        
        if let lastLocation = locations.last {
            let geocoder = CLGeocoder()

            geocoder.reverseGeocodeLocation(lastLocation) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                
                if error == nil {
                    if let firstLocation = placemarks?[0],
                        let firstLocationLocality = firstLocation.locality,
                        let firstLocationCountry = firstLocation.country {
                        
                        self.cityName = firstLocationLocality
                        self.countryName = firstLocationCountry
                    }
                }
            }
        }
    }
}
