//
//  HighScoresViewController.swift
//  Daily Jumble
//
//  Created by Vishal Narayan on 7/30/18.
//  Copyright © 2018 Vishal Narayan. All rights reserved.
//

import UIKit

class HighScoresViewController: UIViewController {
    var data30 = [String]()
    var data60 = [String]()
    var data120 = [String]()
    
    var key = "five30"
    var time = ""
    var length = ""
    
    @IBOutlet weak var scoreText: UITextView!
    
    @IBOutlet weak var lengthOptions: UISegmentedControl!
    
    @IBOutlet weak var timeOptions: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreText.text = String(UserDefaults.standard.integer(forKey: key))
        lengthOptions.addTarget(self, action: #selector(updateScore), for: .valueChanged)
        timeOptions.addTarget(self, action: #selector(updateScore), for: .valueChanged)
        
        AppDelegate.amp.observe(name: "highScoreViewed", properties: ["Mode": "Highscores", "time": 30, "length" : "five"])
    }
    
    @objc func updateScore() {
        switch timeOptions.selectedSegmentIndex {
        case 0:
            time = "30"
        case 1:
            time = "60"
        case 2:
            time = "120"
        default:
            time = "30"
        }
        switch lengthOptions.selectedSegmentIndex {
        case 0:
            length = "five"
        case 1:
            length = "six"
        case 2:
            length = "seven"
        case 3:
            length = "long"
        case 4:
            length = "some"
        default:
            length = "some"
            
        }
        key = length + time
        scoreText.text = String(UserDefaults.standard.integer(forKey: key))
        AppDelegate.amp.observe(name: "highScoreViewed", properties: ["Mode": "Highscores", "time": time, "length" : length])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
