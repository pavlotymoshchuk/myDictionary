//
//  RandomWordViewController.swift
//  myDictionary
//
//  Created by Павло Тимощук on 09.11.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit

class RandomWordViewController: UIViewController {
    
    var translatesArray = [String]()

    @IBOutlet weak var randomWordLabel: UILabel!
    var randomTranslatesButtonsArray = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addFunctionality()
    }
    
    func addFunctionality() {
        var randomUnstudiedWord = Words()
        repeat
        {
            randomUnstudiedWord = wordsArray.randomElement()!
        }
        while randomUnstudiedWord.studied
        randomWordLabel?.text = randomUnstudiedWord.word
        translatesArray.append(randomUnstudiedWord.translate[0])
        
        for _ in 0 ..< 3 {
            var randomTranslateWord = Words()
            repeat
            {
                randomTranslateWord = wordsArray.randomElement()!
            }
            while randomTranslateWord.studied || !translatesArray.isNew(newElement: randomTranslateWord.translate[0]) //MARK: Check for unique
            translatesArray.append(randomTranslateWord.translate[0])
        }
        translatesArray.shuffle()
        
        for i in 0 ..< 4 {
            let randomTranslatesButton = UIButton()
            addButtonViewAndProperties(randomTranslatesButton, i, &randomUnstudiedWord)
            randomTranslatesButtonsArray.append(randomTranslatesButton)
            self.view.addSubview(randomTranslatesButton)
        }
    }
    
    func addButtonViewAndProperties(_ randomTranslatesButton: UIButton, _ i: Int, _ randomUnstudiedWord: inout Words) {
        randomTranslatesButton.tag = (translatesArray[i] == randomUnstudiedWord.translate[0]) ? 1 : 0
        randomTranslatesButton.setTitle(translatesArray[i], for: .normal)
        randomTranslatesButton.titleLabel?.font = UIFont.systemFont(ofSize: 23)
        
        randomTranslatesButton.frame = CGRect(x: 40, y: 220 + i * 60, width: Int(view.frame.width)-80, height: 40)
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                randomTranslatesButton.setTitleColor(.white, for: .normal)
                randomTranslatesButton.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                randomTranslatesButton.layer.borderColor = UIColor.white.cgColor
            } else {
                randomTranslatesButton.setTitleColor(.black, for: .normal)
                randomTranslatesButton.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
                randomTranslatesButton.layer.borderColor = UIColor.black.cgColor
            }
        } else {
            randomTranslatesButton.setTitleColor(.black, for: .normal)
            randomTranslatesButton.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
            randomTranslatesButton.layer.borderColor = UIColor.black.cgColor
        }
        
        randomTranslatesButton.layer.cornerRadius = 5
        randomTranslatesButton.layer.borderWidth = 1
        randomTranslatesButton.addTarget(self, action: #selector(randomTranslatesButtonPress), for: .touchUpInside)
    }
    
    //MARK:- Changing view depends on appearance
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        for item in randomTranslatesButtonsArray {
            if #available(iOS 12.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    item.setTitleColor(.white, for: .normal)
                    item.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
                    item.layer.borderColor = UIColor.white.cgColor
                } else {
                    item.setTitleColor(.black, for: .normal)
                    item.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                    item.layer.borderColor = UIColor.black.cgColor
                }
            } else {
                item.setTitleColor(.black, for: .normal)
                item.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                item.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    @objc func randomTranslatesButtonPress(sender: UIButton) {
        if sender.tag == 1 {
            sender.backgroundColor = .green
        } else {
            sender.backgroundColor = .red
            for item in randomTranslatesButtonsArray {
                if item.tag == 1 {
                    item.backgroundColor = .green
                    break
                }
            }
        }
        for item in randomTranslatesButtonsArray {
            item.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension Array where Element == String  {
    func isNew(newElement: String) -> Bool {
        return !self.contains(newElement)
    }
}
