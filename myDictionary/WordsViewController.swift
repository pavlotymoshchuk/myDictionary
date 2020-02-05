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

class WordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableWords: UITableView!
    
    //MARK: - Refresh
    var refresh = UIRefreshControl()
    
    
    @objc func handleRefresh()
    {
        gettingJSON()
        self.tableWords.reloadData()
        refresh.endRefreshing()
    }
    
    //MARK: - Notification
    func scheduleNotification(notificationRepeat: TimeInterval)
    {
        removeNotification(withIdent: ["Massage"])
        
        let content = UNMutableNotificationContent()
        content.title = "Learn new word"
        var randomWord = Words()
        repeat
        {
            randomWord = wordsArray.randomElement()!
        }
        while randomWord.studied
        
        content.body = randomWord.word + " - " + randomWord.translate[0]
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        var date = DateComponents()
        date.minute = 5
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let request = UNNotificationRequest(identifier: "Massage", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    func removeNotification (withIdent ident: [String])
    {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ident)
    }
    
    deinit {
        removeNotification(withIdent: ["Massage"])
    }
    
    
    
    //MARK: - Отримання JSON
    func gettingJSON(){
        wordsArray.removeAll()
        AF.request("http://pavlo-tymoshchuk-inc.right-k-left.com/word.json").responseJSON {
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
                        self.tableWords.reloadData()
                    }
                case .failure(let error):
                    print("ERROR", error.localizedDescription)
            }
        }
    }
    
    //MARK: - Перестворення JSON
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

    
    //MARK: - viewDidLoad()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        gettingJSON()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        tableWords.addSubview(refresh)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //MARK: - Notification
        if wordsArray.count > 0
        {
            self.scheduleNotification(notificationRepeat: 10)
            print("Notification created")
        }
        else
        {
            print("Array is empty")
        }
        return wordsArray.count
    }

    // MARK: - Заповнення рядків
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as? TableViewCell
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
