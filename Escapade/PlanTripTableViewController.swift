//
//  PlanTripTableViewController.swift
//  Escapade
//
//  Created by Mosab Elagha on 9/19/15.
//  Copyright © 2015 Mosab Elagha. All rights reserved.
//

import UIKit

struct plan {
    var title : String = ""
    var response : String = ""
    var image : String = ""

    var code : String?
}
class PlanTripTableViewController: UITableViewController, MotionEngineDelegate {
    
    var ptr:MotionEngine! = nil
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func selectedSegment(sender: AnyObject) {
        if segmentedControl.selectedSegmentIndex == 0 {
            viewingInfo = information
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            viewingInfo = [information.first!]
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    var selectedIndex : NSIndexPath?
    
    var information = [plan(title: "From", response: "Response", image: "", code : nil), plan(title: "To", response: "", image: "", code : nil), plan(title: "Dates", response: "Response", image: "aa", code : nil), plan(title: "Budget", response: "", image: "", code : nil)]
    
    var viewingInfo : [plan] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewingInfo = information
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        selectedSegment(self)
        self.ptr = MotionEngine()
        self.ptr.initialize(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func landed() -> Bool {
        NSLog("Lol fuck")
        return true
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewingInfo.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath: NSIndexPath) {
        let row = forRowAtIndexPath.row
        cell.textLabel?.text = viewingInfo[row].title
        cell.detailTextLabel?.text = viewingInfo[row].response
        cell.imageView?.image = UIImage(named: viewingInfo[row].image)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath
        let row = indexPath.row
        if viewingInfo[row].title == "From" || viewingInfo[row].title == "To" {
            performSegueWithIdentifier("selectAirport", sender: self)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectAirport" {
            if let destVC = segue.destinationViewController as? AirportSearchTableViewController {
                if selectedIndex?.row == 0 {
                    destVC.editingType = Param.From
                }
                else if selectedIndex?.row == 1 {
                    destVC.editingType = Param.To
                    
                }
            }
        }
    }
}
