//
//  ViewController.swift
//  myDictionary
//
//  Created by Павло Тимощук on 20.01.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ViewController: UIViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        class Words
        {
            var word: String = ""
            var translate: String = ""
        }
        
        AF.request("http://pavlo-tymoshchuk-inc.right-k-left.com/word.json").responseJSON
        {
            response in
            switch response.result
            {
            case .success(let value):
                let json = JSON(value)
                print(json)
                let countWords = json[].count
                print(countWords)
                var wordsArray = [Words]()
                for i in 0..<countWords
                {
                    var curWord = Words()
                    curWord.word = json[i]["word"].string!
                    curWord.translate = json[i]["translate"].string!
                    wordsArray.append(curWord)
                }
                for i in 0..<countWords
                {
                    print(wordsArray[i].word,wordsArray[i].translate)
                }
            
            case .failure(let error):
                print("ERROR", error.localizedDescription)
            }
        }
        
    }


}

