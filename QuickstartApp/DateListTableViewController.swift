//
//  DateListTableViewController.swift
//  QuickstartApp
//
//  Created by Yevgeniy Vasylenko on 6/29/17.
//  Copyright © 2017 Yevgeniy Vasylenko. All rights reserved.
//

import UIKit

protocol DateListDateListTableViewControllerDelegate {
    func pickedDate(vc: DateListTableViewController, didSelectDate: DayOfWeek)
}

class DateListTableViewController: UITableViewController {

    var selectedWeekday: DayOfWeek
    var delegate: DateListDateListTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pick Day of the Week"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init(day: DayOfWeek) {
        selectedWeekday = day
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DayOfWeek.allDays.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cellWeekday = DayOfWeek.allDays[indexPath.row]
        
        
        cell.textLabel?.text = String(describing: cellWeekday)
        
        if cellWeekday == selectedWeekday {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // called when user taps on some row
        
        let prevIndexPath = IndexPath(row: DayOfWeek.allDays.index(of: self.selectedWeekday)!, section: 0)
        let cellWeekday = DayOfWeek.allDays[indexPath.row]
        self.selectedWeekday = cellWeekday
        
        tableView.reloadRows(at: [prevIndexPath, indexPath], with: .automatic);
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.delegate?.pickedDate(vc: self, didSelectDate: selectedWeekday)
    }
}
