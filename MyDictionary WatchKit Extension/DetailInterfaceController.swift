//
//  DetailInterfaceController.swift
//  MyDictionary WatchKit Extension
//
//  Created by Павло Тимощук on 07.05.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import Foundation
import WatchKit

class DetailInterfaceController: WKInterfaceController {
    
    
    @IBOutlet weak var num: WKInterfaceLabel!
    @IBOutlet weak var word: WKInterfaceLabel!
    @IBOutlet weak var translate: WKInterfaceLabel!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let inputData = context as? Words  {
            if inputData.studied {
                num.setTextColor(.green)
                num.setText("Вивчене")
            } else {
                num.setTextColor(.red)
                num.setText("Потрібно вивчити")
            }
            word.setText("Слово: " + inputData.word)
            var translateString = ""
            for i in inputData.translate {
                translateString += "Переклад: " + i + "\n"
            }
            translate.setText(translateString)
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
}
