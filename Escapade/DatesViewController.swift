//
//  DatesViewController.swift
//  Escapade
//
//  Created by Mosab Elagha on 9/20/15.
//  Copyright © 2015 Mosab Elagha. All rights reserved.
//

import UIKit

class DatesViewController: UIViewController {

    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    
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
            
            
            let dateString = "\(printStyler.stringFromDate(startDate.date)) - \(printStyler.stringFromDate(endDate.date))"
            prevVC.information[2].response = dateString
            
            let styler = NSDateFormatter()
            styler.dateFormat = "yyyy-MM-dd"
            
            prevVC.information[2].code = styler.stringFromDate(startDate.date) + "--" + styler.stringFromDate(endDate.date)
            print(prevVC.information[2].code)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    func initDatePickers() {
        startDate.datePickerMode = UIDatePickerMode.Date
        startDate.minimumDate = NSDate()
        startDate.maximumDate = NSDate(timeIntervalSinceNow: 60*60*24*7*52*10)
        
        endDate.datePickerMode = UIDatePickerMode.Date
        endDate.minimumDate = NSDate()
        endDate.maximumDate = NSDate(timeIntervalSinceNow: 60*60*24*7*52*10)
    }
    
    
    @IBAction func startDateChanged(sender: AnyObject) {
        endDate.minimumDate = startDate.date
    }

    func enableEndDate(boolean : Bool) {
        if boolean {
            endDate.enabled = true
        } else {
            endDate.enabled = false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
