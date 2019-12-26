//
//  TabBarViewController.swift
//  Stop Calling Me
//
//  Created by Bastian Oliver Schwickert on 24/12/2019.
//  Copyright © 2019 Bastian Oliver Schwickert. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let number = UserDefaults.standard.string(forKey: "Number")
        
        if (number != nil) {
            print("Number already setup..Skipping segue...")
        }else {
            performSegue(withIdentifier: "number", sender: nil)
        }
        
    }
    
}
