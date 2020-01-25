//
//  MyTableViewController.swift
//  myDictionary
//
//  Created by Павло Тимощук on 25.01.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController {
    
    class Words {
        var word: String = ""
        var translate: [String] = []
        var studied: Bool = false
    }
    var wordsArray = [Words]()
    
    //MARK: Отримання JSON
    func gettingJSON() {
        AF.request("http://pavlo-tymoshchuk-inc.right-k-left.com/words.json").responseJSON {
            response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    let countWords = json[].count
                    print(countWords)
                    
                    for i in 0..<countWords
                    {
                        var curWord = Words()
                        curWord.word = json[i]["word"].string!
                        var curTranslatesCount = json[i]["translate"].count
                        var curTranslatesMas: [String] = []
                        for j in 0..<curTranslatesCount
                        {
                            curTranslatesMas.append(json[i]["translate"][j].string!)
                        }
                        curWord.translate = curTranslatesMas
                        curWord.studied = json[i]["studied"].bool!
                        self.wordsArray.append(curWord)
                    }
                    for i in 0..<countWords
                    {
                        print("Слово: ",self.wordsArray[i].word,". Переклад: ",self.wordsArray[i].translate,". Я його вивчив: ",self.wordsArray[i].studied)
                    }
                case .failure(let error):
                    print("ERROR", error.localizedDescription)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gettingJSON()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsArray.count
    }

    
    let cellIdentifier = "reuseIdentifier"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let item = wordsArray[indexPath.row]
        
        cell.textLabel?.text = item.word
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
