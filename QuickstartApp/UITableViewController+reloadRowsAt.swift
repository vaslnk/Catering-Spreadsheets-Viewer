//
//  ViewControllerExtension.swift
//  QuickstartApp
//
//  Created by Yevgeniy Vasylenko on 7/4/17.
//  Copyright © 2017 Yevgeniy Vasylenko. All rights reserved.
//

import UIKit

extension UITableViewController {
    func reloadRowsOf(old: [String], new: [String])  {
        var toAdd = [IndexPath]()
        var toRemove = [IndexPath]()
        var toReload = [IndexPath]()
        
        //if new array has more elements
        if new.count > old.count {
            // find elements to be added
            for i in 1..<(new.count - old.count + 1) {
                toAdd.append(IndexPath(item: old.count - 1 + i, section: 0))
            }
            for i in 0..<old.count {
                toReload.append(IndexPath(item: i, section: 0))
            }
        }
        
        //if new array has fewer elements
        else if new.count < old.count {
            //find elements to be removed
            
            for i in 1..<(old.count - new.count + 1) {
                toRemove.append(IndexPath(item: -i, section: 0))
            }
        
            for i in 0..<(new.count) {
                toReload.append(IndexPath(item: i, section: 0))
            }
        
        // if same size
        } else {
            for i in 0..<new.count {
                toReload.append(IndexPath(item: i, section: 0))
            }
        }
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: toAdd, with: .automatic)
        self.tableView.deleteRows(at: toRemove, with: .automatic)
        self.tableView.reloadRows(at: toReload, with: .automatic)
        self.tableView.endUpdates()

    }
}
