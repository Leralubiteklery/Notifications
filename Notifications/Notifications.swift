//
//  Notifications.swift
//  Notifications
//
//  Created by Lera Savchenko on 27.05.24.
//  Copyright © 2024 Alexey Efimov. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notofication settings: \(settings)")
        }
    }
    
    func scheduleNotification(notificationType: String) {
        
        let content = UNMutableNotificationContent()
        let userAction = "UserAction"
        
        content.title = notificationType
        content.body = "This is example of how to create" + notificationType
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userAction
        
        guard let path = Bundle.main.path(forResource: "FineImage", ofType: "jpg")  else { return }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let attachment = try UNNotificationAttachment(
                identifier: "FineImage",
                url: url)
            
            content.attachments = [attachment]
        } catch {
            print("The attachment wasn't loaded")
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifier = "Local Notification"
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(
            identifier: userAction,
            actions: [snoozeAction, deleteAction],
            intentIdentifiers: [],
            options: []
        )
        
        notificationCenter.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notification with Local Notification id")
            
            switch response.actionIdentifier {
            case UNNotificationDismissActionIdentifier:
                print("Dismiss action")
            case UNNotificationDefaultActionIdentifier:
                print("Default")
            case "Snooze":
                print("Snooze")
                scheduleNotification(notificationType: "Remider")
            case "Delete":
                print("Delete")
            default:
                print("unknown")
            }
           completionHandler()
        }
    }
}
