//
//  playGameViewController.swift
//  Daily Jumble
//
//  Created by Vishal Narayan on 6/21/18.
//  Copyright © 2018 Vishal Narayan. All rights reserved.
//

import UIKit

class fiveLetterWords: UIViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var lengthOptions: UISegmentedControl!
    
    var randomword = ""
    var length = "five"
    var fiveWords = [String]()
    var sixWords = [String]()
    var sevenWords = [String]()
    var longWords = [String]()
    var allWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        word.delegate = self
        self.word.textColor = UIColor(red:0.60, green:0.40, blue:0.20, alpha:1.0)
        textField.delegate = self
        
        lengthOptions.addTarget(self, action: #selector(setLength), for: .valueChanged)
        importAllTexts()
        AppDelegate.amp.observe(name: "wordViewed", properties: ["Mode": "Free Play", "word": randomword, "length" : length])

    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var word: UITextView!
    
    func importAllTexts() {
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
        word.text = jumble(r: randomword)
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
    
    
    @IBAction func check(_ sender: UIButton) {
        
        if (textField.text!.lowercased() == randomword.lowercased()){
            print("correct")
            word.textColor = UIColor.green
            AppDelegate.amp.observe(name: "Success", properties: ["Mode": "Free Play", "Status": 1])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // change 2 to desired number of seconds
                // Your code with delay
//                let hi  = self.navigationController?.popViewController(animated: true)
                self.randomword = self.allWords[Int(arc4random_uniform(UInt32(self.allWords.count)))]
                print(self.randomword)
                self.word.text = self.jumble(r: self.randomword)
                AppDelegate.amp.observe(name: "wordViewed", properties: ["Mode": "Free Play", "Word": self.randomword, "Length" : self.length])
                self.word.textColor = UIColor(red:0.60, green:0.40, blue:0.20, alpha:1.0)
                self.textField.text = ""
            }
            
        }else{
            word.textColor = UIColor.red
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // change 2 to desired number of seconds
                // Your code with delay
                self.word.textColor = UIColor(red:0.60, green:0.40, blue:0.20, alpha:1.0)
                self.textField.text = ""
            }
            AppDelegate.amp.observe(name: "Failure", properties: ["Mode": "Free Play", "Status": 0, "Word:":randomword, "Guess:": textField.text?.lowercased()])
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    
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
        importAllTexts()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.amp.observe(name: "Exited", properties: ["Mode": "Free Play", "Status": 0])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    


}
