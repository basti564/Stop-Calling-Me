//
//  DetailViewController.swift
//  Stop Calling Me
//
//  Created by Bastian Oliver Schwickert on 24/12/2019.
//  Copyright © 2019 Bastian Oliver Schwickert. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var hideNumber: UISwitch!
    @IBOutlet weak var closeButton: UIButton!

    var noIdPrefix = "*67"
    
    var add = 0
    
    var scammer: ScammerDetail? {
        didSet {
            // Update the view.
            //configureView()
        }
    }

    func configureView() {
        descriptionLabel.text = scammer?.Message
        numberLabel.text = scammer?.Number.applyPatternOnNumbers(pattern: "#-###-###-####", replacmentCharacter: "#")
        countLabel.text = "Called \(scammer!.CallCount) times"
    }
    
    override func viewDidLoad() {
        #if targetEnvironment(macCatalyst)
        closeButton.isHidden = false
        #endif
        super.viewDidLoad()
        if (UserDefaults.standard.string(forKey: "hideNumber") != nil){
            hideNumber.isOn = true
        }
        if (UserDefaults.standard.string(forKey: "networkType") != nil){
            segmentControl.selectedSegmentIndex = 1
        }
        configureView()
    }
    
    @IBAction func dismissClicked(_ sender:UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreInfo(_ sender:UIButton){
        let alert = UIAlertController(title: "More Info", message: "ID: \(scammer?.id ?? 0)\nNumber: \(String(scammer?.Number ?? "n/a"))\nMessage: \(String(scammer?.Message ?? "n/a"))\nPause: \(String(scammer?.Pause ?? "n/a"))\nCallDuration: \(String(scammer?.CallDuration ?? "n/a"))\nCallCount: \(String(scammer?.CallCount ?? "n/a"))\nResponse: \(String(scammer?.Response ?? "n/a"))\nShort: \(String(scammer?.short ?? "n/a"))\nInvestigationNotes: \(String(scammer?.InvestigationNotes ?? "n/a"))", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func switchedSwitch(_ sender:UISwitch){
        if hideNumber.isOn{
            UserDefaults.standard.set(true, forKey: "hideNumber")
        }else{
            UserDefaults.standard.removeObject(forKey: "hideNumber")
        }
    }
    
    @IBAction func switchedSegment(_ sender:UISegmentedControl){
        if segmentControl.selectedSegmentIndex == 1{
            UserDefaults.standard.set("eu", forKey: "networkType")
        }else{
            UserDefaults.standard.removeObject(forKey: "networkType")
        }
    }
    
    @IBAction func startCalling(_ sender:UIButton){
        if hideNumber.isOn{
            if segmentControl.selectedSegmentIndex == 0{
                noIdPrefix = "%2A6700"
            }else{
                noIdPrefix = "%2331%2300"
            }
        }else{
            noIdPrefix = ""
        }
        
        let phoneURL = URL(string: "tel://" + noIdPrefix + (scammer?.Number.applyPatternOnNumbers(pattern: "###########", replacmentCharacter: "#") ?? "12345678900"))!
        
        UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
    
        let parameters = ["id": scammer?.id]
    
        Request().post(urlString: "https://stopcallingme.ca/api/app/spamcount", parameters: parameters as [String : Any])

        countLabel.text = "Called \(Int(scammer!.CallCount) ?? 0 + add) times"
    }

}

extension String {
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
