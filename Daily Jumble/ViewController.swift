//
//  ViewController.swift
//  Daily Jumble
//
//  Created by Vishal Narayan on 6/16/18.
//  Copyright © 2018 Vishal Narayan. All rights reserved.
//

import UIKit
import GoogleSignIn
import UserNotifications

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in })
        
        let content = UNMutableNotificationContent()
        content.title = "You are correct!"
        content.subtitle = "correctamundo"
        content.body = "hello"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func wordList(_ sender: UIButton) {
    }
    
    @IBAction func fiveLetterWords(_ sender: UIButton) {
    }
    
    
    @IBAction func sixLetterWords(_ sender: UIButton) {
    }
    
    @IBAction func sevenLetterWords(_ sender: UIButton) {
    }
    
    @IBAction func longWords(_ sender: UIButton) {
    }
    
    
    
}

