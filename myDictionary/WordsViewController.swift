//
//  MyTableViewController.swift
//  myDictionary
//
//  Created by Павло Тимощук on 25.01.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit
import SwiftyJSON
import UserNotifications

class WordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableWords: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredWords = [Words]()
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    //MARK: - Refresh
    var refresh = UIRefreshControl()
    
    
    @objc func handleRefresh() {
        gettingJSON()
        self.tableWords.reloadData()
        refresh.endRefreshing()
    }
    
    //MARK: - Notification
    func scheduleNotification(notificationRepeat: TimeInterval) {
        removeNotification(withIdent: ["Massage"])
        
        let content = UNMutableNotificationContent()
        content.title = "Learn new word"
        var randomWord = Words()
        repeat {
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
    
    func removeNotification (withIdent ident: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ident)
    }
    
    deinit {
        removeNotification(withIdent: ["Massage"])
    }
    
    
    
    //MARK: - Отримання JSON
    func gettingJSON() {
        if let path = Bundle.main.path(forResource: "File", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                wordsArray = try JSONDecoder().decode([Words].self, from: data)
            } catch let error {
                print("error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }        
    }
    
    @IBAction func newWordButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewWordViewController")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - Alert with random word
    func alertWithRandomWord() {
        let showRandomWord = UIAlertController()
        showRandomWord.title = "Random word:"
        var randomUnstudiedWord = Words()
        repeat {
            randomUnstudiedWord = wordsArray.randomElement()!
        }
        while randomUnstudiedWord.studied
        showRandomWord.message = randomUnstudiedWord.word + " - " + randomUnstudiedWord.translate[0]
        let action = UIAlertAction(title: "OK", style: .cancel) { (UIAlertAction) in }
        showRandomWord.addAction(action)
        present(showRandomWord, animated: true, completion: nil)
    }
    
    @IBAction func randomWord(_ sender: UIButton) {
//        alertWithRandomWord()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RandomWordViewController")
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    //MARK: - viewDidLoad()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        gettingJSON()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableWords.addSubview(refresh)
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        if #available(iOS 11.0, *) {
            self.tableWords.tableHeaderView = self.searchController.searchBar
        }
        definesPresentationContext = true
        
    }
    
    // MARK: - Sorting Words Array
    func sortingWordsArray(sortParam: Int)
    {
        var unknownWordsArray: [Words] = []
        var knownWordsArray: [Words] = []
        for i in wordsArray {
            if i.studied && i.word.count != 0 {
                knownWordsArray.append(i)
            } else if i.word.count != 0 {
                unknownWordsArray.append(i)
            }
        }
        switch sortParam {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if wordsArray.count > 0 {
            //MARK: - Notification
            self.scheduleNotification(notificationRepeat: 10)
            // MARK: - Sorting By
            sortingWordsArray(sortParam: sortParam)
        }
        //MARK: - Filtering
        if isFiltering {
            return filteredWords.count
        } else {
            return wordsArray.count
        }
    }

    // MARK: - Заповнення рядків
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as? TableViewCell {
            //MARK: - Filtering
            let item: Words
            if isFiltering {
                item = filteredWords[indexPath.row]
            } else {
                item = wordsArray[indexPath.row]
            }
//            let item = wordsArray[indexPath.row]
            cell.wordLabel?.text = item.word
            cell.translateLabel?.text = item.translate[0]
            cell.numberLabel?.text = String(indexPath.row+1)
            if item.studied {
                cell.numberLabel?.textColor = UIColor.green
            } else {
                cell.numberLabel?.textColor = UIColor.red
            }
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: - SearchResults
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredWords = wordsArray.filter({ (word: Words) -> Bool in
            return word.translate[0].lowercased().contains(searchText.lowercased()) || word.word.lowercased().contains(searchText.lowercased())
        })
        tableWords.reloadData()
    }

}
