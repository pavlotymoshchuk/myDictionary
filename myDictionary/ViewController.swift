//
//  ViewController.swift
//  myDictionary
//
//  Created by Павло Тимощук on 20.01.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ViewController: UIViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        AF.request("http://pavlo-tymoshchuk-inc.right-k-left.com/word.json").responseJSON
        {
            response in
            switch response.result
            {
            case .success(let value):
                let json = JSON(value)
                print(json)
            case .failure(let error):
                print("ERROR", error.localizedDescription)
            }
        }
        
    }


}

