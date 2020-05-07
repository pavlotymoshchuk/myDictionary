//
//  InterfaceController.swift
//  MyDictionary WatchKit Extension
//
//  Created by Павло Тимощук on 05.05.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import WatchKit
import Foundation

struct Words: Decodable
{
    var word: String
    var translate: [String]
    var studied: Bool
}
var wordsArray: [Words] = []
var sortParam = 0

func sortingWordsArray(sortParam: Int)
{
    var unknownWordsArray: [Words] = []
    var knownWordsArray: [Words] = []
    for i in wordsArray
    {
        if i.studied && i.word.count != 0
        {
            knownWordsArray.append(i)
        }
        else if i.word.count != 0
        {
            unknownWordsArray.append(i)
        }
    }
    switch sortParam
    {
    case 0:
        wordsArray = unknownWordsArray.sorted {$0.word < $1.word} + knownWordsArray.sorted {$0.word < $1.word}
    case 1:
        wordsArray = unknownWordsArray.sorted {$0.translate[0] < $1.translate[0]} + knownWordsArray.sorted {$0.translate[0] < $1.translate[0]}
    case 2:
        wordsArray = knownWordsArray.sorted {$0.word < $1.word} + unknownWordsArray.sorted {$0.word < $1.word}
    case 3:
        wordsArray = knownWordsArray.sorted {$0.translate[0] < $1.translate[0]} + unknownWordsArray.sorted {$0.translate[0] < $1.translate[0]}
    default:
        return
    }
    
}

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    func loadTable() {
        self.tableView.setNumberOfRows(wordsArray.count, withRowType: "RowController")
        for index in 0 ..< wordsArray.count {
            if let rowController = self.tableView.rowController(at: index) as? RowController {
                rowController.num.setText(String(index+1))
                wordsArray[index].studied ? rowController.num.setTextColor(.green) : rowController.num.setTextColor(.red)
                rowController.word.setText(wordsArray[index].word)
                rowController.translate.setText(wordsArray[index].translate[0])
            }
        }
    }
    
    func loadWordsFromJSON() {
        let urlString = "http://pavlo-tymoshchuk-inc.right-k-left.com/wordsArray.json"
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) {
                    data, response, error in
                    if let data = data {
                        do {
                            wordsArray = try JSONDecoder().decode([Words].self, from: data)
                            sortingWordsArray(sortParam: sortParam)
                            print(wordsArray)
                            self.loadTable()
                        } catch let error {
                            print(error)
                        }
                    }
                }.resume()
            }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        loadWordsFromJSON()
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        pushController(withName: "DetailInterfaceController", context: (wordsArray[rowIndex]))
    }
    
    
    
}
