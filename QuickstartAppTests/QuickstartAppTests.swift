//
//  QuickstartAppTests.swift
//  QuickstartAppTests
//
//  Created by Yevgeniy Vasylenko on 6/25/17.
//  Copyright © 2017 Yevgeniy Vasylenko. All rights reserved.
//

import XCTest

class QuickstartAppTests: XCTestCase {
    
    var mock = MockSheetService()
    var model : FoodModel?
    var expectedNames = [String]()
    var expectedMealsList = [String]()
    var expectation: XCTestExpectation?
    
    
    var testNamesExpectation : XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        model = FoodModel(sheetService: mock, day: DayOfWeek.Monday)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testNames() {
        if let model = self.model {
            expectedNames = ["Стив Нэш", "Леброн Джеймс"]
            model.getPersonNames(day: DayOfWeek.Monday, completionHandler: {(err, namesList) in
                XCTAssertEqual(self.expectedNames, namesList)
            })
        }
    }
    
    func testMeals() {
        if let model = self.model {
            expectedMealsList = ["Овощи микс", "Овощной бульон", "Рыба на пару"]
            model.getMealsFor(name:  "Леброн Джеймс", day: DayOfWeek.Monday, completionHandler: {(err, mealsList) in
                XCTAssertEqual(self.expectedMealsList, mealsList)
            })
        }
    }
    
    func testMealsErrors() {
        if let model = self.model {
            mock.giveMeError = true
            model.getMealsFor(name:  "Леброн Джеймс", day: DayOfWeek.Monday, completionHandler: {(err, mealsList) in
                XCTAssertTrue(err != nil)
            })
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
