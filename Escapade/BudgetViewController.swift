//
//  BudgetViewController.swift
//  Escapade
//
//  Created by Mosab Elagha on 9/20/15.
//  Copyright © 2015 Mosab Elagha. All rights reserved.
//

import UIKit

class BudgetViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var budgetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSlider()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "saveAndReturn")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sliderSlid(sender: AnyObject) {
        let budget = (slider.value) * 1000
        budgetLabel.text = "$\(floor(budget))"
    }
    
    func initSlider() {
        slider.value = 0.2
        sliderSlid(self)
    }
    
    var backViewController : UIViewController? {
        
        var stack = self.navigationController!.viewControllers as Array
        
        for (var i = stack.count-1 ; i > 0; --i) {
            if (stack[i] == self) {
                return stack[i-1]
            }
        }
        return nil
    }
    func saveAndReturn() {
        if let prevVC = backViewController as? PlanTripTableViewController {
            
            prevVC.information[3].response = "$\(floor(slider.value * 1000))"
            prevVC.information[3].code = "\(floor(slider.value * 1000))"
            
            self.navigationController?.popViewControllerAnimated(true)
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
