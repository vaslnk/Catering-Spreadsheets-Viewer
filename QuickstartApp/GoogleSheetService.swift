//
//  GoogleSheetService.swift
//  QuickstartApp
//
//  Created by Yevgeniy Vasylenko on 6/30/17.
//  Copyright © 2017 Yevgeniy Vasylenko. All rights reserved.
//

import UIKit
import Google
import GoogleAPIClientForREST
import GoogleSignIn


class GoogleSheetService: NSObject, SheetService {
    let service: GTLRSheetsService
    
    
    init(service: GTLRSheetsService) {
        self.service = service
    }
    
    func loadSheetForDate(date: String, completionHandler: @escaping (Error?, [[String]]?) -> Void) {
        let spreadsheetId = "1tpj0OTIpYf4LCK7wp3oU7316k12NjYxxzF2edswpkxM"
        let range = date
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: spreadsheetId, range:range)
        
        service.executeQuery(query) { (ticket, result, error) in
            let fullArray = (result as? GTLRSheets_ValueRange)?.values as? [[String]]
            completionHandler(error, fullArray)
        }
    }

}
