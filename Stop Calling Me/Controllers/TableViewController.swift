//
//  TableViewController.swift
//  Stop Calling Me
//
//  Created by Bastian Oliver Schwickert on 24/12/2019.
//  Copyright © 2019 Bastian Oliver Schwickert. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    var listOfScammers = [ScammerDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tabBarController?.tabBar.items?[0].badgeValue = String(self.listOfScammers.count)
            }
        }
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self

        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        let timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
        timer.fire()
        }
    
    @objc func refresh(){
        Request().getScammers(){ [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let scammers):
                self?.listOfScammers = scammers
            }
        }
        self.refreshControl?.endRefreshing()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return listOfScammers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let scammer = listOfScammers[indexPath.row]
        
        cell.detailTextLabel?.text = "\(scammer.short) - \(scammer.CallCount) calls"
        cell.textLabel?.text = scammer.Number
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        return cell
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            guard let selectedTableViewCell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: selectedTableViewCell)
                else { preconditionFailure("Expected sender to be a valid table view cell") }

            guard let detailViewController = segue.destination as? DetailViewController
                else { preconditionFailure("Expected a DetailViewController") }

            detailViewController.scammer = listOfScammers[indexPath.row]
        }
    }
    
    
}
