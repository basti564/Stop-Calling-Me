//
//  SecondViewController.swift
//  Stop Calling Me
//
//  Created by Bastian Oliver Schwickert on 23/12/2019.
//  Copyright © 2019 Bastian Oliver Schwickert. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var phoneNumber : UITextField!
    @IBOutlet weak var descriptionField : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionField.delegate = self
    }
    
    @IBAction func submit(_ sender:UIButton){
        let number = UserDefaults.standard.string(forKey: "Number")
        let parameters = ["Number": phoneNumber.text?.filter("0123456789".contains) as Any, "Notes": descriptionField.text as Any, "From": number as Any, "STATUS": "UNDER INVESTIGATION"] as [String : Any]
        
        Request().post(urlString: "https://stopcallingme.ca/api/app/add", parameters: parameters)
        
        let alert = UIAlertController(title: "Thank you for your Help!", message: "You've successfully submitted \(String(phoneNumber.text ?? "phone number")) for investugation.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)

    }
    
    @IBAction func cancel(_ sender:UIButton){
        self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if (textView.text == "Description of the call" && textView.textColor == .placeholderText){
            textView.text = ""
            textView.textColor = .label
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        if (textView.text == ""){
            textView.text = "Description of the call"
            textView.textColor = .placeholderText
        }
        textView.resignFirstResponder()
    }

}
