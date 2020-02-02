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
import UserNotifications

class TableViewController: UITableViewController {
    
    var refresh = UIRefreshControl()
    
    
    @objc func handleRefresh()
    {
        gettingJSON()
        self.tableView.reloadData()
        refresh.endRefreshing()
    }
    
    //MARK: - Отримання JSON
    func gettingJSON(){
        wordsArray.removeAll()
        AF.request("http://pavlo-tymoshchuk-inc.right-k-left.com/words.json").responseJSON {
            response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    print(json)
                    for i in 0 ..< json[].count
                    {
                        let curWord = Words()
                        curWord.word = json[i]["word"].string!
                        var curTranslatesMas: [String] = []
                        for j in 0 ..< json[i]["translate"].count
                        {
                            curTranslatesMas.append(json[i]["translate"][j].string!)
                        }
                        curWord.translate = curTranslatesMas
                        curWord.studied = json[i]["studied"].bool!
                        wordsArray.append(curWord)
                    }
                    if wordsArray.count > 0
                    {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("ERROR", error.localizedDescription)
            }
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
            print(jsonString)
        }
    }
    
    func creatingJSON()
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
        print(jsonString)
    }
    
//    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        gettingJSON()
        self.refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        view.addSubview(refresh)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return wordsArray.count
    }

    // MARK: - Заповнення рядків
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell
        {
            let item = wordsArray[indexPath.row]
            cell.wordLabel?.text = item.word
            cell.translateLabel?.text = item.translate[0]
            cell.numberLabel?.text = String(indexPath.row+1)
            if item.studied
            {
                cell.numberLabel?.textColor = UIColor.green
            }
            else
            {
                cell.numberLabel?.textColor = UIColor.red
            }
            return cell
        }
        return UITableViewCell()
    }

}
