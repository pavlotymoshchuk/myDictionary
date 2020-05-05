//
//  NewWordViewController.swift
//  myDictionary
//
//  Created by Павло Тимощук on 02.02.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit

class NewWordViewController: UIViewController,UITextFieldDelegate
{
    func creatingJSON() -> String
    {
        var jsonString = ""
        jsonString += "[" + "\n"
        if wordsArray.count > 0
        {
        for i in 0 ..< wordsArray.count
            {
                jsonString += "{" + "\n" + "\u{0022}" + "word" + "\u{0022}" + ":" + "\u{0022}" + wordsArray[i].word + "\u{0022}" + "," + "\n"
                jsonString += "\u{0022}" + "translate" + "\u{0022}" + ":" + "["
                for j in 0 ..< wordsArray[i].translate.count
                {
                    jsonString += "\u{0022}" + wordsArray[i].translate[j] + "\u{0022}" + ","
                }
                jsonString.remove(at: jsonString.index(before: jsonString.endIndex))
                jsonString += "]" + "," + "\n"
                jsonString += "\u{0022}" + "studied" + "\u{0022}" + ":" + String(wordsArray[i].studied) + "\n" + "}" + "," + "\n"
            }
        }
        jsonString.remove(at: jsonString.index(before: jsonString.endIndex))
        jsonString.remove(at: jsonString.index(before: jsonString.endIndex))
        jsonString += "\n" + "]"
        return jsonString
    }


    @IBOutlet weak var  newWordTextField: UITextField!
    @IBOutlet weak var  newTranslateTextField: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        newTranslateTextField.delegate = self
        newWordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addNewWordButton(_ sender: UIButton)
    {
        var newWord = Words()
        newWord.studied = false
        newWord.word = newWordTextField.text!
        newWord.translate.append(newTranslateTextField.text!)
        wordsArray.append(newWord)
        print(newWord.word,newWord.translate)
        //MARK: - Відміна відкриття view
        dismiss(animated: true, completion: nil)
    }

}


