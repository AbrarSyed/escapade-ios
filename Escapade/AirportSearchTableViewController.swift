//
//  AirportSearchTableViewController.swift
//  Escapade
//
//  Created by Mosab Elagha on 9/19/15.
//  Copyright © 2015 Mosab Elagha. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum Param {
    case From
    case To
    case Dates
    case Price
}

class AirportSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    var editingType : Param! {
        didSet {
            print(editingType)
        }
    }
    
    var base = ["Current Location"]
    var results : [String] = ["Current Location"] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var apiResponse : JSON = "" {
        didSet {
            results = base + parseJSON()
//            print("response: ", apiResponse.array, separator: "\n", terminator: "")
        }
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
    
    func parseJSON() -> [String] {
        var apiResults : [String] = []
        
        for k in apiResponse {
            apiResults.append(k.1["label"].string ?? "")
        }
        
        return apiResults
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        getSearchResults(searchText)
    }
    
    // MARK: - Alamofire
    func getSearchResults(query : String) {
        let url = "https://escapade.abrarsyed.com/flights/airportAutoComplete?text=" + query
        request(.GET, url)
            .response { (request, response, result, error) -> Void in
//                print("\nrepsone", response, "\nrequest", request, "\nresult", result, "\nerror", error)
//                print( JSON(data: result!))
                let ok = JSON(data: result!)
                self.apiResponse = ok
        }
    }
    
    // MARK: - Search bar 
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath: NSIndexPath) {
        let row = forRowAtIndexPath.row
        cell.textLabel?.text = results[row]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        passDataBack(indexPath)
    }
    
    func passDataBack(indexPath : NSIndexPath) {
        if let prevVC = backViewController as? PlanTripTableViewController {
            
            let data = apiResponse[indexPath.row - 1]
            
            if editingType == Param.From {
                prevVC.information[0].response = data["label"].string ?? ""
                prevVC.information[0].code = data["value"].string ?? ""
                
                if indexPath.row == 0 {
                    prevVC.information[0].response = "Current Location"
                    prevVC.information[0].code = "location"
                }
            }
            
            if editingType == .To {
                prevVC.information[1].response = data["label"].string ?? ""
                prevVC.information[1].code = data["value"].string ?? ""
                
                if indexPath.row == 0 {
                    prevVC.information[1].response = "Current Location"
                    prevVC.information[1].code = "location"
                }
            }
            
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

    
}
