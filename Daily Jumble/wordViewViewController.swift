//
//  wordViewViewController.swift
//  Daily Jumble
//
//  Created by Vishal Narayan on 6/16/18.
//  Copyright © 2018 Vishal Narayan. All rights reserved.
//

import UIKit

class wordViewViewController: UIViewController{

    
    var objects = [String]()
    var allWords = [String]()
    var randomword = ""
    var scoreValue = 0
    
    var counter: Int = 0;
    var total: Int = 1000;
    
    var key = ""
    
    @IBOutlet weak var word: UITextView!
    
    @IBOutlet weak var score: UITextView!
    
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var dimmer: UIView!
    
    @IBOutlet weak var playAgain: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var timeOptions: UISegmentedControl!
    
    @IBOutlet weak var lengthOptions: UISegmentedControl!
    
    var seconds = 0.0
    var time = 30
    var timeSelected = 0.0
    var lengthSelected = 5
    var length = "five"
    var timer = Timer()
    var isTimerRunning = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("The Progress Bar is at: \(progress.progress)")
        score.text = "0"
        scoreValue = 0
        dimmer.isHidden = false
        startbutton.isHidden = false
        playAgain.isHidden = true
        timeOptions.isHidden = false
        lengthOptions.isHidden = false
        skipButton.isHidden = true
        seconds = 0.0
        timeSelected = 1/30
        isTimerRunning = false

        progress.setProgress(0.0, animated: false)
        
        word.text = "Pick length and time"
        

        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        timeOptions.addTarget(self, action: #selector(setTime), for: .valueChanged)
        lengthOptions.addTarget(self, action: #selector(setLength), for: .valueChanged)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.playGame), userInfo: nil, repeats: true)
    }
    
    @objc func playGame() {
        key = length + String(time)
        dimmer.isHidden = true
        startbutton.isHidden = true
        timeOptions.isHidden = true
        lengthOptions.isHidden = true
        skipButton.isHidden = false
        textField.isHidden = false
        textField.becomeFirstResponder()
        
        if seconds >= 1.0 {
            textField.resignFirstResponder()
            textField.isHidden = true
            playAgain.isHidden = false
            skipButton.isHidden = true
            timer.invalidate()
            
            key = length + String(time)
            AppDelegate.amp.observe(name: "timeOver", properties: ["Mode": "Time Trial", "Score": scoreValue, "Word": randomword, "Length" : length])
            if UserDefaults.standard.integer(forKey: key) < scoreValue {
                UserDefaults.standard.set(scoreValue, forKey: key)
                AppDelegate.amp.observe(name: "highscoreAchieved", properties: ["Mode": "Time Trial", "Score": scoreValue, "Word": randomword, "Length" : length])
            }
        }
        self.progress.setProgress(Float(seconds), animated: true)
        seconds += timeSelected
    }
    
    @IBOutlet weak var startbutton: UIButton!
    @IBAction func start(_ sender: UIButton) {
        startbutton.isHidden = true
        AppDelegate.amp.observe(name: "timeTrialSettings", properties: ["Mode": "Time Trial", "Time": time, "Length" : length])
        
        if let startWordsPath = Bundle.main.path(forResource: length, ofType: "txt"){
            do{
                let startWords = try String(contentsOfFile: startWordsPath, encoding: String.Encoding.utf8)
                allWords = startWords.components(separatedBy: "\n")
            } catch let error as NSError {
                print(error)
            }
        }
        else {
            allWords = ["silkworm"]
        }
        randomword = allWords[Int(arc4random_uniform(UInt32(allWords.count)))]
        print(randomword)
        AppDelegate.amp.observe(name: "wordViewed", properties: ["Mode": "Time Trial", "Word": randomword, "Length" : length])
        
        word.text = jumble(r: randomword)
        runTimer()
    }

    @IBAction func playagain(_ sender: UIButton) {
        AppDelegate.amp.observe(name: "PlayAgain", properties: ["Mode": "Time Trial", "Status": 1])
        self.viewDidLoad()
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (textField.text!.lowercased() == randomword.lowercased()){
            scoreValue += 1
            AppDelegate.amp.observe(name: "Success", properties: ["Mode": "Time Trial", "Status": 1])
            randomword = allWords[Int(arc4random_uniform(UInt32(allWords.count)))]
            AppDelegate.amp.observe(name: "wordViewed", properties: ["Mode": "Time Trial", "Word": randomword, "Length" : length])
            print(randomword)
            word.text = jumble(r: randomword)
            textField.text = ""
        }
        score.text = String(scoreValue)
    }
    @objc func setTime(){
        switch timeOptions.selectedSegmentIndex {
        case 0:
            timeSelected = 1/30
            time = 30
        case 1:
            timeSelected = 1/60
            time = 60
        case 2:
            timeSelected = 1/120
            time = 120
        default:
            timeSelected = 1/60
            time = 60
        }
    }
    @objc func setLength(){
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
        
    }

    @IBAction func skip(_ sender: UIButton) {
        randomword = allWords[Int(arc4random_uniform(UInt32(allWords.count)))]
        print(randomword)
        scoreValue -= 1
        AppDelegate.amp.observe(name: "Skip", properties: ["Mode": "Time Trial", "Status": -1])
        score.text = String(scoreValue)
        word.text = jumble(r: randomword)
        textField.text = ""
    }
    

    
    func jumble(r: String) -> String {
        var chars = Array(r.characters)
        var last = chars.count - 1
        var shuffledString = ""
        while(last > 0)
        {
            let rand = Int(arc4random_uniform(UInt32(last)))
            //print("swap items[\(last)] = \(chars[last]) with items[\(rand)] = \(chars[rand])")
            chars.swapAt(last, rand)
            shuffledString = String(chars)
            last -= 1
        }
        return shuffledString
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        AppDelegate.amp.observe(name: "Exited", properties: ["Mode": "Time Trial", "Status": 0, "Score": scoreValue])
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
