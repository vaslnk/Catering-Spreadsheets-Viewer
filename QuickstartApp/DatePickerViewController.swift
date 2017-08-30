//
//  ViewController.swift
//  QuickstartApp
//
//  Created by Yevgeniy Vasylenko on 6/28/17.
//  Copyright © 2017 Yevgeniy Vasylenko. All rights reserved.
//

import UIKit

protocol DatePickerDelegate {
    func datePicker(vc: DatePicker, didSelectDay day:String)
}

class DatePicker: UIViewController {
    var picker = UIPickerView.init(frame: CGRect.init(x: 50, y: 50, width: 50, height: 50))
    var textField = UITextField()
    var delegate: DatePickerDelegate?
    var days: [String]?
    var lastPicked = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        textField.inputView = picker
        self.view.addSubview(picker)
        days = ["Понедельник ", "Вторник", "Среда ", "Четверг ", "Пятница "]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.datePicker(vc: self, didSelectDay: (self.days?[lastPicked])!)
    }
    
}
extension DatePicker: UIPickerViewDataSource {
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }

}

extension DatePicker: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
//        let days = ["Понедельник ", "Вторник", "Среда ", "Четверг ", "Пятница "]
        return self.days?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        lastPicked = row
    }

}
