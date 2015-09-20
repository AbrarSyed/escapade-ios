//
//  ReturnViewController.swift
//  Escapade
//
//  Created by Mosab Elagha on 9/20/15.
//  Copyright © 2015 Mosab Elagha. All rights reserved.
//

import UIKit

class ReturnViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!

    var backViewController : UIViewController? {
        
        var stack = self.navigationController!.viewControllers as Array
        
        for (var i = stack.count-1 ; i > 0; --i) {
            if (stack[i] == self) {
                return stack[i-1]
            }
            
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        initDatePickers()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "saveAndReturn")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveAndReturn() {
        if let prevVC = backViewController as? PlanTripTableViewController {
            
            let printStyler = NSDateFormatter()
            printStyler.dateFormat = "MM/dd/yyyy"
            
            
            let dateString = "\(printStyler.stringFromDate(datePicker.date))"
            prevVC.information[3].response = dateString
            
            let styler = NSDateFormatter()
            styler.dateFormat = "yyyy-MM-dd"
            
            prevVC.information[3].code = styler.stringFromDate(datePicker.date)
            print(prevVC.information[3].code)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    func initDatePickers() {
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.minimumDate = NSDate()
        datePicker.maximumDate = NSDate(timeIntervalSinceNow: 60*60*24*7*52*10)
    }
}
