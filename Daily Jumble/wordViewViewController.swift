//
//  wordViewViewController.swift
//  Daily Jumble
//
//  Created by Vishal Narayan on 6/16/18.
//  Copyright © 2018 Vishal Narayan. All rights reserved.
//

import UIKit
import GoogleSignIn


class wordViewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var objects = [String]()
    var allWords = [String]()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        if let startWordsPath = Bundle.main.path(forResource: "some", ofType: "txt"){
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
        
        
    
    }
    
    public func words() -> [String]{
        return(allWords)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(allWords.count)
    }
    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = allWords[indexPath.row]
        return(cell)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
