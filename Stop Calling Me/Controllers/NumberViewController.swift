//
//  NumberViewController.swift
//  Stop Calling Me
//
//  Created by Bastian Oliver Schwickert on 24/12/2019.
//  Copyright © 2019 Bastian Oliver Schwickert. All rights reserved.
//

import UIKit

class NumberViewController: UIViewController {
    
    @IBOutlet var phoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func submit(_ sender:UIButton){
        UserDefaults.standard.set(phoneNumber.text?.filter("0123456789".contains), forKey: "Number")
                
        let parameters = ["Number": phoneNumber.text?.filter("0123456789".contains)]
        
        Request().post(urlString: "https://stopcallingme.ca/api/app/add", parameters: parameters as [String : Any])
        
        dismiss(animated: true, completion: nil)
    }
    
}
