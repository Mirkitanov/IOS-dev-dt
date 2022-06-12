//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Админ on 12.06.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import Foundation
import UserNotifications

protocol NotificationsServise {
    func registeForLatestUpdatesIfPossible()
}

final class LocalNotificationsService: NSObject, NotificationsServise {
    
    // MARK: - Public properties
    
    static let shared = LocalNotificationsService()
    
    // MARK: - Public Methods
    
    public func registeForLatestUpdatesIfPossible() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.provisional, .alert, .badge, .sound]
        ) { granted, error in
            if granted {
                print("Доступ к уведомлениям получен")
                self.scheduleNotification()
            } else {
                print("Доступ не получен")
                print(error?.localizedDescription ?? "Some error")
            }
        }
    }

    private func scheduleNotification() {
        registerUpdatesCategory()
        
        let content = UNMutableNotificationContent()
        content.title = "Новое уведомление"
        content.body = "Посмотрите последние обновления"
        content.sound = .default
        content.categoryIdentifier = "updates"
        
        UNUserNotificationCenter.current().delegate = self
        
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    private func registerUpdatesCategory() {
        let actions = UNNotificationAction(identifier: "tapAction", title: "Установить последние обновления", options: [.foreground])
        let category = UNNotificationCategory(identifier: "updates", actions: [actions], intentIdentifiers: [])
    
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension LocalNotificationsService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
         switch response.actionIdentifier {
         case "tapAction":
            print("Данные обновлены! Мы работаем для Вашего удобства!")
         case UNNotificationDefaultActionIdentifier:
            print("Default Identifier")
         default:
            break
        }
        completionHandler()
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .sound])
    }
}


