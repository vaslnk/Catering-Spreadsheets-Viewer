//
//  FoodSheetModel.swift
//  QuickstartApp
//
//  Created by Yevgeniy Vasylenko on 6/27/17.
//  Copyright © 2017 Yevgeniy Vasylenko. All rights reserved.
//

import UIKit


class FoodModel: NSObject {
    
    let sheetService: SheetService
    var fullArray : [[String]]?
    var wasNames = true
    var day: DayOfWeek?
    var namesCompletionHandler: ((Error?, [String]) -> Void)?
    var mealsCompletionHandler: ((Error?, [String]) -> Void)?
    
    init(sheetService: SheetService, day: DayOfWeek) { //  remove from constructor
        self.sheetService = sheetService
        self.day = day
    }
    
    
    func getPersonNames(day: DayOfWeek, completionHandler: @escaping (Error?, [String]) -> Void) {
        self.namesCompletionHandler = completionHandler
        let oldDay = self.day
        self.day = day
        wasNames = true
        if fullArray != nil && oldDay == day {
            writeToNamesCompletionHandler()
        } else {
            sheetService.loadSheetForDate(date: String(describing: day), completionHandler: { (err, array) in
                if let err = err {
                    self.namesCompletionHandler!(err, [])
                } else {
                self.fullArray = array!
                self.writeToNamesCompletionHandler()
                }
            })
        }
    }
    
    
    private func writeToNamesCompletionHandler() {
        if fullArray!.count < 3 {
            // send error to delegate
            return
        }
        var array = [String]()
        for i in 2..<(fullArray!.count) {
            array.append(fullArray![i][0])
        }
        wasNames = false
        namesCompletionHandler?(nil, array)
    }
    
    
    func getMealsFor(name: String, day: DayOfWeek,completionHandler: @escaping (Error?, [String]) -> Void) {
        let oldDay = self.day
        self.day = day
        mealsCompletionHandler = completionHandler
        wasNames = false
        if fullArray != nil && oldDay == day {
            writeToMealsCompletionHandler(name: name)
        } else {
            sheetService.loadSheetForDate(date: String(describing: day), completionHandler: { (err, array) in
                if let err = err {
                    self.mealsCompletionHandler!(err, [])
                } else {
                    self.fullArray = array!
                    self.writeToMealsCompletionHandler(name: name)
                }
            })
        }
    }
    
    private func writeToMealsCompletionHandler(name: String) {
        var array = [String]()
        for row in fullArray! {
            if row[0] == name {
                for i in 0..<row.count {
                    if row[i] == "1" {
                        array.append((fullArray![1][i]))
                    }
                }
            }
        }
        mealsCompletionHandler!(nil, array)
    }
    
}
