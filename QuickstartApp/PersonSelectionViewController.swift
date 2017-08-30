//
//  PersonSelectionViewController.swift
//  QuickstartApp
//
//  Created by Yevgeniy Vasylenko on 6/26/17.
//  Copyright © 2017 Yevgeniy Vasylenko. All rights reserved.
//

import UIKit


protocol PersonSelectionViewControllerDelegate {
    
    func personSelectionViewController(vc:PersonSelectionViewController, didSelectPerson personName:String);
    func logOutGoogle()
}

class PersonSelectionViewController: UITableViewController {

    var delegate : PersonSelectionViewControllerDelegate?
    var array =  [String]()
    
    
    
    required init() {
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadArray(namesList: [String]) {
        let oldArray = self.array
        self.array = namesList
        if oldArray.count != 0 {
            reloadRowsOf(old: oldArray, new: array)
        } else {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pick a Name"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        let logOutButton = UIBarButtonItem(
            title: "Log Out",
            style: .plain,
            target: self,
            action: #selector(leftButtonAction(sender:))
        )
        self.navigationItem.leftBarButtonItem = logOutButton
        
    }
    
    
    func leftButtonAction(sender: UIBarButtonItem) {
        self.delegate?.logOutGoogle()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // called when user taps on some row
        self.delegate?.personSelectionViewController(vc: self, didSelectPerson: (self.array[indexPath.row]))
    }
    
}
