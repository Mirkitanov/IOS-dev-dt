//
//  MapViewController.swift
//  Navigation
//
//  ХВ. Слава Отцу и Сыну и Святому Духу!
//  Created by Админ on 15.06.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, AlertPresenter {
    
    // MARK: - Properties
    ///Координатор
    weak var flowCoordinator: MapCoordinator?
    
    /// Настраиваемая служба определения местоположения на основе `CLLocationManager`
    private let locationService: LocationService
    
    /// Временная булавка (Пин) для отображения, пока Пользователь решает, что делать
    private var temporaryPin: MKPointAnnotation?
    
    /// Массив, содержащий все установленные пины
    private var userPins: [MKPointAnnotation] = []
    
    /// Пин для отображения в пункте назначения маршрута
    private var routeDestination: MKPointAnnotation?
    
    /// Рисунок маршрута
    private var routeOverlay: MKPolyline?
    
    /// Текущее местоположение Пользователя
    private var currentLocation: CLLocationCoordinate2D?
    
    /// Текущая Страна, согласно местоположения Пользователя
    private var currentCountry: String = ""
    
    // Текущий Город, согласно местоположения Пользователя
    private var currentCity: String = ""
    
    /// Флаг, указывающий необходимость отображения названия текущих Города и Страны в поле `Title` экрана
    private var shouldDisplayCityAndCoutryOnTitle = true
    
    /**
     Флаг, указывающий, была ли карта установлена на позиции Пользователя.
     
     Этот флаг предотвращает постоянное центрирование карты на Пользователе, позволяя простую навигацию
     */
    private var isMapRegionSet = false
    
    ///Основное View для отображения Карты
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.toAutoLayout()
        mapView.mapType = .mutedStandard
        mapView.showsScale = true
        mapView.pointOfInterestFilter = .includingAll
        mapView.showsBuildings = true
        mapView.showsCompass = true
        mapView.showsUserLocation = true
        return mapView
    }()
    
    
    /// View для отображения, когда местоположение пользователя недоступно
    private lazy var unavailableView: LockMapView = {
        let unavailableView = LockMapView()
        unavailableView.toAutoLayout()
        
        unavailableView.setButtonAction {
            guard let bundleID = Bundle.main.bundleIdentifier,
                  let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleID)"),
                  UIApplication.shared.canOpenURL(url) else {
                return
            }
            UIApplication.shared.open(url)
            
        }
        
        return unavailableView
    }()
    
    /// Констреинты для `unavailableView`
    private lazy var unavailableViewConstraints = [
        unavailableView.topAnchor.constraint(equalTo: view.topAnchor),
        unavailableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        unavailableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        unavailableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]
    
    /// Флаг, указывающий, было ли View «заблокировано»/'locked' (было показано `unavailableView`)
    private var isViewLocked = false
    
    ///Кнопка для захвата текущего местоположения Пользователя
    private lazy var currentUserLocationButton: UIButton = {
        let locationButton = UIButton()
        locationButton.clipsToBounds = true
        locationButton.layer.masksToBounds = false
        locationButton.layer.shadowColor = UIColor.black.cgColor
        locationButton.layer.shadowOffset.width = 5
        locationButton.layer.shadowOffset.height = 5
        locationButton.layer.shadowOpacity = 0.4
        locationButton.layer.shadowRadius = 4
        locationButton.setBackgroundImage(UIImage(systemName: "location.fill"), for: .normal)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.addTarget(self, action: #selector(currentUserLocationButtonTapped(_:)), for: .touchUpInside)
        return locationButton
    }()
    
    ///Кнопка для Zoom "+"
    private lazy var zoomPlusButton: UIButton = {
        let zoomButton = UIButton()
        zoomButton.clipsToBounds = true
        zoomButton.layer.masksToBounds = false
        zoomButton.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        zoomButton.translatesAutoresizingMaskIntoConstraints = false
        zoomButton.addTarget(self, action:#selector(zoomPlusButtonTapped(_:)), for: .touchUpInside)
        return zoomButton
    }()
    
    ///Кнопка для Zoom "-"
    private lazy var zoomMinusButton: UIButton = {
        let zoomButton = UIButton()
        zoomButton.clipsToBounds = true
        zoomButton.layer.masksToBounds = false
        zoomButton.setBackgroundImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        zoomButton.translatesAutoresizingMaskIntoConstraints = false
        zoomButton.addTarget(self, action:#selector(zoomMinusButtonTapped(_:)), for: .touchUpInside)
        return zoomButton
    }()
    
    private var adressLabel: UILabel  = {
        let adressLabel = UILabel()
        adressLabel.backgroundColor = UIColor(named: "Hex-code: #4885CC")
        adressLabel.contentMode = .scaleAspectFill
        adressLabel.clipsToBounds = true
        adressLabel.layer.masksToBounds = false
        
        adressLabel.layer.shadowColor = UIColor.black.cgColor
        adressLabel.layer.shadowOffset.width = 5
        adressLabel.layer.shadowOffset.height = 5
        adressLabel.layer.shadowOpacity = 0.2
        adressLabel.layer.shadowRadius = 0.5
        
        adressLabel.layer.cornerRadius = 10
        adressLabel.layer.borderWidth = 3
        adressLabel.layer.borderColor = UIColor.white.cgColor
        adressLabel.textColor = .white
       
        adressLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        adressLabel.translatesAutoresizingMaskIntoConstraints = false
        adressLabel.sizeToFit()
        return adressLabel
    }()
    
    // MARK: - Initialization
    
    init(locationService: LocationService) {
        self.locationService = locationService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adressLabel.isHidden = true
        locationService.delegate = self
        mapView.delegate = self
        
        setupUI()
        setupMenu()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationService.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationService.stop()
    }
    
    //MARK: - Actions
    
    ///Обработка долгого нажатия на Карту
    @objc private func mapLongPressed(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            temporaryPin = createPin(at: touchPoint)
            displayTouchActionRequest(at: touchPoint)
        }
    }
    
    /// Обрабатывает нажатие Кнопки `currentUserLocationButton`
    @objc private func currentUserLocationButtonTapped(_ sender: Any) {
        showMyCurrentLocation()
    }
    
    /// обрабатывает приближение масштабирования
    @objc private func zoomPlusButtonTapped(_ sender: Any){
        mapView.setZoomByDelta(delta: 0.5, animated: true)
        
    }
    
    /// обрабатывает оттаделние масштабирования
    @objc private func zoomMinusButtonTapped(_ sender: Any){
        mapView.setZoomByDelta(delta: 2, animated: true)
    }
    
    // MARK: - UI
    /// Настройка для установки элементов UI
    private func setupUI() {
        view.addSubviews(mapView,
                         currentUserLocationButton,
                         zoomPlusButton,
                         zoomMinusButton,
                         adressLabel)
        
        let constraints = [
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            currentUserLocationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            currentUserLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            currentUserLocationButton.heightAnchor.constraint(equalToConstant: 40),
            currentUserLocationButton.widthAnchor.constraint(equalToConstant: 40),
            
            zoomPlusButton.topAnchor.constraint(equalTo: currentUserLocationButton.bottomAnchor, constant: 50),
            zoomPlusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            zoomPlusButton.heightAnchor.constraint(equalToConstant: 40),
            zoomPlusButton.widthAnchor.constraint(equalToConstant: 40),
            
            zoomMinusButton.topAnchor.constraint(equalTo: zoomPlusButton.bottomAnchor, constant: 20),
            zoomMinusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            zoomMinusButton.heightAnchor.constraint(equalToConstant: 40),
            zoomMinusButton.widthAnchor.constraint(equalToConstant: 40),
            
            adressLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            adressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(mapLongPressed(_:)))
        gestureRecognizer.minimumPressDuration = 1
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    /// Отображает список действий с опциями «Проложить маршрут» и «Поставить точку»
    private func displayTouchActionRequest(at touchPoint: CGPoint) {
        
        let alertController = UIAlertController(title: "Выберите действие", message: nil, preferredStyle: .actionSheet)
        
        let routeAction = UIAlertAction(title: "Проложить маршрут", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if let temporaryPin = self.temporaryPin {
                self.createRoute(to: temporaryPin)
            }
        }
        alertController.addAction(routeAction)
        
        let pinAction = UIAlertAction(title: "Поставить точку", style: .default) { [weak self] _ in
            self?.displayPinRequest(at: touchPoint)
        }
        alertController.addAction(pinAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { [weak self] _ in
            self?.removeTemporaryPin()
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /// Отображает предупреждение с возможностью установки имени и описания Пина (Точки)
    private func displayPinRequest(at touchPoint: CGPoint) {
        let alertController = UIAlertController(title: "Поставить точку", message: "Введите название и подзаголовок", preferredStyle: .alert)
        
        alertController.addTextField { titleTextField in
            titleTextField.placeholder = "Название точки"
        }
        
        alertController.addTextField { subtitleTextField in
            subtitleTextField.placeholder = "Описание точки"
        }
        
        let addPinAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            self?.removeTemporaryPin()
            let title = alertController.textFields?[0].text
            let subtitle = alertController.textFields?[1].text
            self?.createPin(at: touchPoint, temporary: false, title: title, subtitle: subtitle)
        }
        
        alertController.addAction(addPinAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { [weak self] _ in
            self?.removeTemporaryPin()
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// Сбрасывает вид карты до исходного масштаба и центрирует вокруг положения Пользователя
    private func resetMapRegion(for location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    /// Сбрасывает вид карты до исходного масштаба и центрирует вокруг положения Пользователя с более точным приближением масштаба
    private func setUserPreciseRegion(for location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    ///Отображение названия текущего Города и Станы, относительно местоположения Пользователя, в поле `Title` экрана
    private func displayCityAndCountryOnTitle(){
        
        currentCity = locationService.cityName
        
        currentCountry = locationService.countryName
        
        if shouldDisplayCityAndCoutryOnTitle {
            self.navigationItem.title = currentCity + " " + currentCountry
        } else {
            self.navigationItem.title = ""
        }
        shouldDisplayCityAndCoutryOnTitle.toggle()
        
    }
    
    /// Всплывающий и исчезающий Label с названием Города и Страны, относительно местоположения Пользователя
    func displayAndHideAdress(){
        adressLabel.isHidden = false
        currentCity = locationService.cityName
        currentCountry = locationService.countryName
        self.adressLabel.alpha = 1
        self.adressLabel.text = "   " + currentCity + " " + currentCountry + "   "
        
        UIView.animate(withDuration: 1, delay: 1, options: .curveLinear, animations: { [self] in
            self.adressLabel.alpha = 0
            
        }) { _ in
            self.adressLabel.isHidden = true
        }
    }
    
    /// Захват текущей локации Пользователя и установка на ней центра экрана
    func showMyCurrentLocation() {
        // Задаем центр Карты
        if let centerCoordinates = self.currentLocation {
            mapView.setCenter(centerCoordinates, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) { [self] in
                 displayAndHideAdress()
             }
    }
    
    /// Настройка Меню
    private func setupMenu() {
        
        let showMyLocationItem = UIAction(title: "Моё точное местоположение", image: UIImage(systemName: "location.fill.viewfinder")) { [unowned self] (action) in
            
            //Центруем локацию по местоположению Пользователя
            showMyCurrentLocation()
            
            // Масштабируем ближе
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                self.setUserPreciseRegion(for: currentLocation ?? .init(latitude: 0, longitude: 0))
            }
        }
        
        let localityItem = UIAction(title: "Показать/скрыть город моего местоположения", image: UIImage(systemName: "binoculars.fill")) { [unowned self ] (action) in
            displayCityAndCountryOnTitle()
        }
        
        let removeMapPinsItem = UIAction(title: "Убрать все точки/пины", image: UIImage(systemName: "smallcircle.circle")) { [unowned self] (action) in
            self.removeAllPins()
            self.clearRoute(resettingMap: true)
        }
        
        /// Установка меню в NavigationBar
        let menu = UIMenu(title: "Map Menu",
                          options: .displayInline,
                          children: [showMyLocationItem,
                                     localityItem,
                                     removeMapPinsItem])
        
        let infoBarItem: UIBarButtonItem = UIBarButtonItem(
            title: "Меню",
            menu: menu
        )
    
        self.navigationItem.rightBarButtonItem = infoBarItem
    }
    
    // MARK: - Routes
    
    /// Создает маршрут от текущего местоположения до пункта назначения
    private func createRoute(to destination: MKPointAnnotation) {
        clearRoute(resettingMap: false)
        
        guard let sourceLocation = currentLocation else { return }
        self.routeDestination = destination
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        let destinationPlacemark = MKPlacemark(coordinate: destination.coordinate)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] (response, error) -> Void in
            
            guard let response = response else {
                
                var errorMessage = "Невозможно построить маршрут"
                
                if let error = error {
                    errorMessage += ": \(error.localizedDescription)"
                }
                
                self?.presentErrorAlert(errorMessage)
                self?.removeTemporaryPin()
                return
            }
            
            let route = response.routes[0]
            
            self?.routeOverlay = route.polyline
            self?.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            self?.mapView.setUserTrackingMode(.followWithHeading, animated: true)
        }
    }
    
    /// Удаление маршрута и очистка всех смежных свойств; опционально сброс вида карты
    private func clearRoute(resettingMap shouldResetMapRegion: Bool) {
        if let routeDestination = self.routeDestination,
           !userPins.contains(routeDestination) {
            mapView.removeAnnotation(routeDestination)
        }
        
        self.routeDestination = nil
        
        if let routeOverlay = self.routeOverlay {
            mapView.removeOverlay(routeOverlay)
            self.routeOverlay = nil
            mapView.setUserTrackingMode(.none, animated: true)
        }
        
        if let currentLocation = self.currentLocation,
           shouldResetMapRegion {
            resetMapRegion(for: currentLocation)
        }
    }
    
    // MARK: - Pins
    /**
     Добавить Пин (Точку) на mapView
     
     - parameters:
     - touchPoint: `CGPoint` место установки Точки
     - temporary: Флаг, показывающий, что Точка временная  (смотрите описание в  **Descussion**). По умолчанию установлено в `true`
     - title: Название Точки (optional)
     - subtitle: Описание точки (optional)
     
     Пин (Точка) может быть _временным_ — автоматически созданным пином, который Пользователь может видеть, пока решает, что с ним делать.
     Такой вывод будет немедленно удален, если не будет предпринято никаких действий (не будет "Проложен маршрут" или  "Закреплена/поставлена точка").
     Если пользователь строит маршрут к временному пину, этот пин всегда очищается при очистке маршрута.
     
     */
    @discardableResult
    private func createPin(at touchPoint: CGPoint, temporary: Bool = true, title: String? = nil, subtitle: String? = nil) -> MKPointAnnotation {
        let touchCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchCoordinates
        annotation.title = title
        annotation.subtitle = subtitle
        
        mapView.addAnnotation(annotation)
        
        if !temporary {
            userPins.append(annotation)
        }
        return annotation
    }
    
    /// Удаляет временную булавку (Пин) с карты и сбрасывает объект
    private func removeTemporaryPin() {
        if let tmpPin = temporaryPin {
            mapView.removeAnnotation(tmpPin)
        }
        temporaryPin = nil
    }
    
    /// Удаляет все Пины с карты и сброс всех свойств Пин и Маршрута
    private func removeAllPins() {
        mapView.removeAnnotations(mapView.annotations)
        userPins.removeAll()
        temporaryPin = nil
        routeDestination = nil
    }
    
}

// MARK: - LocationServiceDelegate

extension MapViewController: LocationServiceDelegate {
    
    func received(location: CLLocationCoordinate2D) {
        if !isMapRegionSet {
            resetMapRegion(for: location)
            isMapRegionSet = true
        }
        
        currentLocation = location
    }
    
    func determinedServiceUnavailable(permanently: Bool) {
        isViewLocked = true
        view.addSubview(unavailableView)
        NSLayoutConstraint.activate(unavailableViewConstraints)
        unavailableView.makeButton(visible: !permanently)
    }
    
    func determinedServiceAvailable() {
        if isViewLocked {
            NSLayoutConstraint.deactivate(unavailableViewConstraints)
            unavailableView.removeFromSuperview()
            isViewLocked = false
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let pin = view.annotation as? MKPointAnnotation else { return }
        
        let alertController = UIAlertController(title: pin.title ?? "Точка", message: pin.subtitle, preferredStyle: .actionSheet)
        
        let deleteActionTitle: String
        
        if pin == self.routeDestination {
            if self.userPins.contains(pin) {
                let clearRouteAction = UIAlertAction(title: "Очистить маршрут", style: .destructive) { [weak self] _ in
                    self?.clearRoute(resettingMap: true)
                    mapView.deselectAnnotation(pin, animated: true)
                }
                alertController.addAction(clearRouteAction)
            }
            
            deleteActionTitle = "Удалить точку и очистить маршрут"
        } else {
            let routeAction = UIAlertAction(title: "Проложить маршрут", style: .default) { [weak self] _ in
                self?.createRoute(to: pin)
                mapView.deselectAnnotation(pin, animated: true)
            }
            alertController.addAction(routeAction)
            
            deleteActionTitle = "Удалить точку"
        }
        
        let deleteAction = UIAlertAction(title: deleteActionTitle, style: .destructive) { [weak self] _ in
            mapView.removeAnnotation(pin)
            self?.userPins.removeAll { $0 == pin }
            if pin == self?.routeDestination {
                self?.clearRoute(resettingMap: true)
            }
        }
        alertController.addAction(deleteAction)
        
        var deleteAllActionTitle = "Удалить все точки"
        if let _ = routeDestination {
            deleteAllActionTitle += " и очистить маршрут"
        }
        let deleteAllAction = UIAlertAction(title: deleteAllActionTitle, style: .destructive) { [weak self] _ in
            self?.removeAllPins()
            self?.clearRoute(resettingMap: true)
        }
        alertController.addAction(deleteAllAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            mapView.deselectAnnotation(pin, animated: true)
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.alpha = 0.65
        renderer.lineWidth = 6.0
        
        return renderer
    }
    
}

extension MKMapView {
    // Метод установки zoom
    // delta – это Коэффициент масштабирования (zoom)
    // Предполагается следующая величина коэффициента delta:
    // 1) для отдаления – delta = 2
    // 2) для приближения – delta = 0.5
    
    func setZoomByDelta(delta: Double, animated: Bool) {
        var zoomRegion = region
        var zoomSpan = region.span
        
        func zoomActive(){
            zoomSpan.latitudeDelta *= delta
            print("zoomSpan.latitudeDelta = \(zoomSpan.latitudeDelta)")
            zoomSpan.longitudeDelta *= delta
            print("zoomSpan.longitudeDelta = \(zoomSpan.longitudeDelta)")
            zoomRegion.span = zoomSpan
            setRegion(zoomRegion, animated: animated)
        }
        
        if delta > 1 {
            if zoomSpan.latitudeDelta < 50, zoomSpan.longitudeDelta < 50 {
                zoomActive()
            }
        } else  {
            if zoomSpan.latitudeDelta > 0.001, zoomSpan.longitudeDelta > 0.001 {
                zoomActive()
            }
        }
    }
}


