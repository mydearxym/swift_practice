//
//  ViewController.swift
//  LoveFinder
//
//  Created by mydear-xym on 14-10-29.
//  Copyright (c) 2014年 xieyiming. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var gender: UISegmentedControl!
    
    @IBOutlet weak var birthday: UIDatePicker!
    
    @IBOutlet weak var heightNumber: UISlider!
    
    @IBOutlet weak var height: UILabel!
    
    @IBOutlet weak var hasProperty: UISwitch!
    
    @IBOutlet weak var result: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        name.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func heightChanged(sender: AnyObject) {
        var slider = sender as UISlider
        var i = Int(slider.value)
        //slider.value = Float(i)

        height.text = "\(i)cm"
        
    }
    
    @IBAction func okTapped(sender: AnyObject) {
        let genderText = gender.selectedSegmentIndex == 0 ? "高富帅":"白富美"
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        let now = NSDate()
        let components = gregorian.components(NSCalendarUnit.YearCalendarUnit, fromDate: birthday.date, toDate: now, options: NSCalendarOptions(0))

        let age = components.year
        let hasPropertyText = hasProperty.on ? "有房":"无房"
        
        result.text = "\(name.text), \(age)岁, \(genderText), 身高:\(height.text), \(hasProperty), 求交往!"
        
        println(result.text)
    }

    // UITextFiledDelegate, 让键盘消失
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}

