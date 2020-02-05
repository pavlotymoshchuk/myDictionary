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
        
        //MARK: - відміна відкриття в'ю контролера
        dismiss(animated: true, completion: nil)
    }
    
    

}
