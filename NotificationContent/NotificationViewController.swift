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
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }

    @IBAction func likeButtonTapped(_ sender: Any) {
    }
    
    @IBAction func openAppButton(_ sender: Any) {
    }
    
}
