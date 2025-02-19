//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by Lera Savchenko on 18.02.25.
//  Copyright © 2025 Alexey Efimov. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet var label: UILabel?
    @IBOutlet weak var likeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNotificationCategories()
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
        switch response.actionIdentifier {
        case "Snooze":
            let actions = [
                UNNotificationAction(identifier: "5 sec", title: "Snooze for 5 seconds"),
                UNNotificationAction(identifier: "10 sec", title: "Snooze for 10 seconds"),
                UNNotificationAction(identifier: "1 min", title: "Snooze for 1 minute")
            ]
            
            extensionContext?.notificationActions = actions
            
        case "5 sec":
            reminder(timeInterval: 5)
            dismissNotification()
        case "10 sec":
            reminder(timeInterval: 10)
            dismissNotification()
        case "1 min":
            reminder(timeInterval: 60)
            dismissNotification()
        case "Dismiss":
            dismissNotification()
        default:
            dismissNotification()
        }
    }
    
    func reminder(timeInterval: Double) {
        
        let content = UNMutableNotificationContent()
        
        content.title = "Reminder"
        content.body = "Are you fine?"
        content.sound = .default
        content.categoryIdentifier = "User Action"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(
            identifier: "Local Notification",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func setNotificationCategories() {
        
        let actions = [
            UNNotificationAction(identifier: "Snooze", title: "Snooze", options: []),
            UNNotificationAction(identifier: "Dismiss", title: "Dismiss", options: [.destructive])
        ]
        
        let category = UNNotificationCategory(
            identifier: "User Action",
            actions: actions,
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func openApp() {
        extensionContext?.performNotificationDefaultAction()
    }
    
    func dismissNotification() {
        extensionContext?.dismissNotificationContentExtension()
    }

    @IBAction func likeButtonTapped(_ sender: Any) {
        likeButton.setTitle("♥︎", for: .normal)
    }
    
    @IBAction func openAppButton(_ sender: Any) {
        openApp()
    }
    
}
