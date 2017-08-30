//
//  FoodSheetModel.swift
//  QuickstartApp
//
//  Created by Yevgeniy Vasylenko on 6/27/17.
//  Copyright © 2017 Yevgeniy Vasylenko. All rights reserved.
//
import Google
import GoogleAPIClientForREST
import UIKit

protocol FoodSheetModelDelegate {
    
    func foodSheetModel(vc: FoodSheetModel, didReceiveNamesList namesList: [String])
    func foodSheetModel(vc: FoodSheetModel, didReceiveMealsList mealsList: [String])
    func dontAnimate()
    
}

class FoodSheetModel: NSObject {
    var fullArray : [[String]]?
    var service : GTLRSheetsService
    var delegate: FoodSheetModelDelegate?
    var wasNames = true
    var name: String?
    var day: String?
    var dateChanged = false
    
    // Get current date
    func getDayOfWeek()->Int? {
        let todayDate = NSDate()
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate as Date)
        return weekDay
    }
    
    // TODO: will use GTLRSpreadsheetService not array
    init(service: GTLRSheetsService, day: String) {
        self.service = service
        self.day = day
    }
    
    
    func loadDataFromService() {
        let spreadsheetId = "1NrPDjp80_7venKB0OsIqZLrq47jbx9c-lrWILYJPS88"
        let range = self.day
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: spreadsheetId, range:range!)
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(saveArray(ticket:finishedWithObject:error:))
        )
    }
    
    
    // save elements from the sheet to an array
    func saveArray(ticket: GTLRServiceTicket,
                   finishedWithObject result : GTLRSheets_ValueRange,
                   error : NSError?) {
        fullArray = result.values! as? [[String]]
        if wasNames {
            notifyDelegateAboutPersonNames()
        } else {
            notifyDelegateAboutMealsList(name: name!)
        }
        
    }
    
    
    //Get names of all people on the list
    func getPersonNames(day: String) {
        self.day = day
        // do we have fullArray?
        wasNames = true
        if fullArray != nil && !dateChanged {
            notifyDelegateAboutPersonNames()
        } else {
            loadDataFromService()
        }
    }
    
    func getNamesAndMealFor(day: String, name: String) {
        self.delegate?.dontAnimate()
        getPersonNames(day: day)
        getMealsFor(name: name)
    }
    
    func changedDate(was: Bool) {
        self.dateChanged = was
    }
    
    
    func notifyDelegateAboutPersonNames() {
        if fullArray!.count < 3 {
            // send error to delegate
            return
        }
        var array = [String]()
        for i in 2..<(fullArray!.count) {
            array.append(fullArray![i][0])
        }
        wasNames = false
        self.delegate?.foodSheetModel(vc: self, didReceiveNamesList: array)
    }
    
    
    
    //Get list of meals for a person
    func getMealsFor(name: String) {
        // do we have fullArray?
        // if not — load data
        // when data is loaded, perform getPersonNames and call delegate method
        self.name = name
        wasNames = false
        if fullArray != nil && !dateChanged {
            notifyDelegateAboutMealsList(name: name)
        } else {
            loadDataFromService()
        }
    }
    
    func notifyDelegateAboutMealsList(name: String) {
        var array = [String]()
        let userFullName = name
        for row in fullArray! {
            if row[0] == userFullName {
                for i in 0..<row.count {
                    if row[i] == "1" {
                        array.append((fullArray![1][i]))
                    }
                }
            }
        }
        self.delegate?.foodSheetModel(vc: self, didReceiveMealsList: array)
    }
    
}
