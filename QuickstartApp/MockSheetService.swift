//
//  MockSheetService.swift
//  QuickstartApp
//
//  Created by Yevgeniy Vasylenko on 7/3/17.
//  Copyright © 2017 Yevgeniy Vasylenko. All rights reserved.
//

import UIKit

class MockSheetService: NSObject, SheetService {

    var fullArray = [[String]]()
    var giveMeError = false
    

    required override init() {
        fullArray.append([" ", "Салаты", "", "", "Супы", "", "", "Основные блюда", "", "", "Гарнир"])
        fullArray.append(["", "Салат из свежих овощей", "Салат из свежей капусты", "Овощи микс", "Овощной бульон", "Бульон из домашней курицы", "Солянка", "Отварная куринная грудинка", "Куринная отбивная", "Рыба на пару", "Рис  отварной с маслом", "Картофельное пюре", "Каша гречневая"])
        fullArray.append(["Стив Нэш", "", "", "1", "1", "", "", "1", "", "", "", "1"])
        fullArray.append(["Леброн Джеймс", "", "", "1", "1", "", "", "", "", "1"])
        super.init()
    }
    
    
    func loadSheetForDate(date: String, completionHandler: @escaping (Error?, [[String]]?) -> Void) {
        
        if self.giveMeError {
            let err = NSError.init(domain: "my domain", code: 42, userInfo: nil)
            completionHandler(err, nil)
        }
        else {
            completionHandler(nil, fullArray)
        }
    }
    

}
