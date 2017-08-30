//
//  MealsList.swift
//  QuickstartApp
//
//  Created by Yevgeniy Vasylenko on 6/26/17.
//  Copyright © 2017 Yevgeniy Vasylenko. All rights reserved.
//

import UIKit


protocol MealsListDelegate {
    func mealsListDidPressDateButton(vc:MealsList)
}


class MealsList: UITableViewController {
    
    var list: [String]? {

        didSet {
            if let oldValue = oldValue {
                reloadRowsOf(old: oldValue, new: self.list!)
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    
    var delegate: MealsListDelegate?
    var headerLabel: UILabel?
    var date: DayOfWeek

    
    init(date: DayOfWeek) {
        self.date = date
        super.init(style: .plain)
    }
    
    
    func setDay(day: DayOfWeek) {
        self.date = day
        self.headerLabel?.text = "Food for \(date)"
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.title = "Menu"
        
        //Adding table header
        let view1: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 320, height: 30));
        let label: UILabel = UILabel.init(frame: CGRect(x: 22, y: 0, width: 320, height: 30))
        label.text = "Food for \(date)"
        self.headerLabel = label
        
        label.font = UIFont.boldSystemFont(ofSize: 23.0)
        label.textColor = UIColor.black
        view1.addSubview(label);
        self.tableView.tableHeaderView = view1;
        
        //Adding Date button
        let rightButtonItem = UIBarButtonItem(
            title: "Date",
            style: .plain,
            target: self,
            action: #selector(rightButtonAction(sender:))
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    


    func rightButtonAction(sender: UIBarButtonItem) {
        self.delegate?.mealsListDidPressDateButton(vc: self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let list = list {
            return list.count
        } else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = list?[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // called when user taps on some row
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
