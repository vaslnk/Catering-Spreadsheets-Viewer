//
//  FlowController.swift
//  QuickstartApp
//
//  Created by Yevgeniy Vasylenko on 6/27/17.
//  Copyright © 2017 Yevgeniy Vasylenko. All rights reserved.
//
import GoogleAPIClientForREST
import GoogleSignIn
import UIKit

// MARK: - Flow controller delegate -

@objc
class FlowController: NSObject, PersonSelectionViewControllerDelegate, GoogleLoginDelegate, MealsListDelegate, DateListDateListTableViewControllerDelegate, UINavigationControllerDelegate  {
    
    let week = [DayOfWeek.Monday, .Monday, .Monday, .Tuesday, .Wednesday, .Thursday, .Friday]
    let nc: UINavigationController
    let meals = MealsList(date: .Monday)
    let personSelect = PersonSelectionViewController()
    var googleService: GTLRSheetsService?
    var foodSheet: FoodModel!
    var name: String? {
        get {
            return UserDefaults.standard.string(forKey: "name")
        }
        
        set(newName) {
            if let newName = newName {
                UserDefaults.standard.set(newName, forKey: "name")
            }
            else {
                UserDefaults.standard.removeObject(forKey: "name")
            }
        }
    }
    var google = GoogleLogin()
    var loggedOut = false
    var indexOfPerson: Int?
    var dayOfWeek: DayOfWeek = DayOfWeek.current()
    
    
    init(navigationController: UINavigationController) {
        
        self.nc = navigationController
        super.init()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(significantTimeChange(notification:)),
                                               name: NSNotification.Name.UIApplicationSignificantTimeChange,
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterBackground(notification:)),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: nil);
        
        self.nc.delegate = self

    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === personSelect {
            self.name = nil
        }
    }
    
    @objc func significantTimeChange(notification: Notification) {
        dayOfWeek = DayOfWeek.current()
        updatePersonSelectionViewController()
    }
    
    
    @objc func didEnterBackground(notification: Notification) {
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.synchronize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func start() {
        let g = GoogleLogin()
        g.delegate = self
        self.google = g
        nc.viewControllers = [google]
        meals.setDay(day: dayOfWeek)
        meals.delegate = self
    }
    
    func logOutGoogle() {
        self.loggedOut = true
        google.logout()
        start()
    }
    
    func googleLogin(vc: GoogleLogin, didFinishAuth service: GTLRSheetsService) {
        let loadFromWeb = GoogleSheetService(service: service)
        foodSheet = FoodModel(sheetService: loadFromWeb, day: dayOfWeek)
        requestPersonSelection()
    }

    func requestPersonSelection() {
        updatePersonSelectionViewController()
        self.personSelect.delegate = self
        self.nc.viewControllers = [self.personSelect]
        if let name = self.name {
            self.personSelectionViewController(vc: self.personSelect, didSelectPerson: name)
        }
    }
    
    func updatePersonSelectionViewController() {
        foodSheet.getPersonNames(day: dayOfWeek, completionHandler: { (err, namesList) in
            self.personSelect.loadArray(namesList: namesList)
            if let name = self.name {
                let indexPathOfPerson = IndexPath(item: namesList.index(of: name)!, section: 0)
                self.personSelect.tableView.selectRow(at: indexPathOfPerson, animated: true, scrollPosition: .middle)
                self.updateMealsListViewController()
            }
        })
    }
    
    func updateMealsListViewController() {
        foodSheet.getMealsFor(name: self.name!, day: dayOfWeek, completionHandler: { (err, mealsList) in
            if err != nil {
                showAlert(vc: self.nc, title: "Something went wrong", message: "Meals list unavailable")
            } else {
                self.meals.setDay(day: self.dayOfWeek)
                self.meals.list = mealsList
            }})
    }
    
    
    func personSelectionViewController(vc: PersonSelectionViewController, didSelectPerson personName: String) {
        self.name = personName
        updatePersonSelectionViewController()
        updateMealsListViewController()
        self.nc.pushViewController(meals, animated: true)
    }
    
    
    func mealsListDidPressDateButton(vc: MealsList) {
        let datePick = DateListTableViewController(day: dayOfWeek)
        datePick.delegate = self
        nc.pushViewController(datePick, animated: true)
    }
    
    func pickedDate(vc: DateListTableViewController, didSelectDate day: DayOfWeek) { 
        nc.popViewController(animated: true)
        let oldDayOfWeek = self.dayOfWeek
        dayOfWeek = day
        foodSheet.getPersonNames(day: day, completionHandler: { (err, namesList) in
            if err != nil {
                showAlert(vc: self.nc, title: "No data for that day", message: "Back to previously selected day")
                self.dayOfWeek = oldDayOfWeek
            } else {
            self.personSelect.loadArray(namesList: namesList)
            self.meals.setDay(day: self.dayOfWeek)
            self.foodSheet.getMealsFor(name: self.name!, day: self.dayOfWeek, completionHandler: { (err, mealsList) in
                if err != nil {
                    showAlert(vc: self.nc, title: "Something went wrong", message: "Meals list unavailable")
                } else {
                self.meals.list = mealsList
                }
            })
            }
        })
    }
    
}




