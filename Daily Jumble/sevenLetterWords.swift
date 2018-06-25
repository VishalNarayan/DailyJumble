//
//  sevenLetterWords.swift
//  Daily Jumble
//
//  Created by Vishal Narayan on 6/23/18.
//  Copyright © 2018 Vishal Narayan. All rights reserved.
//

import UIKit

class sevenLetterWords: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var randomword = ""
    var allWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        word.delegate = self
        textField.delegate = self
        
        if let startWordsPath = Bundle.main.path(forResource: "seven", ofType: "txt"){
            do{
                let startWords = try String(contentsOfFile: startWordsPath, encoding: String.Encoding.utf8)
                //print(startWords)
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
        
        word.text = jumble(r: randomword)
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var word: UITextView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func check(_ sender: UIButton) {
        if (textField.text!.lowercased() == randomword.lowercased()){
            print("correct")
            word.textColor = UIColor.green
            
            
        }else{
            word.textColor = UIColor.red
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
