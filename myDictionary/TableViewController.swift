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
    
    //MARK: Отримання JSON
    func gettingJSON() -> [Words]{
        AF.request("http://pavlo-tymoshchuk-inc.right-k-left.com/words.json").responseJSON {
            response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    print(json)
                    for i in 0..<json[].count
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
                        wordsArray.append(curWord)
                    }
                    if wordsArray.count > 0
                    {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("ERROR", error.localizedDescription)
            }
            
        }
        return wordsArray
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        gettingJSON()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return wordsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell
        {
            let item = wordsArray[indexPath.row]
            cell.wordLabel?.text = item.word
            cell.translateLabel?.text = item.translate[0]
            return cell
        }
        return UITableViewCell()
    }

}
