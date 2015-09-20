//
//  ItinerariesTableViewController.swift
//  Escapade
//
//  Created by Mosab Elagha on 9/20/15.
//  Copyright © 2015 Mosab Elagha. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Itinerary {
    var airlineImage: String
    var airlineName: String
    var departTime: String
    var departAirport: String
    var numberOfStops: String
    var landingTime: String
    var landingAirport: String
    var flightTime: String
    var flightCost: String
    var hotelImage: String
    var hotelName: String
    var hotelRating: CGFloat
    var hotelCost: String
}

extension NSDate {
    
    var dayMonthYear: (Int, Int, Int) {
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: self)
        return (components.day, components.month, components.year)
    }
}

class ItinerariesTableViewController: UITableViewController {

    var departLoc : String!
    var destLoc : String?
    var departDate : String!
    var returnDate : String!
    var budget : String!
    
    var data : JSON = "" {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    // MARK: - Alamofire
    func getSearchResults(query : String) {
        let url = "https://escapade.abrarsyed.com/trips/buildTripList" + query
        request(.POST, url, parameters: ["departLoc" : departLoc, "destLoc" : destLoc "departDate"  : departDate, "returnDate" : returnDate, "budget" : budget], encoding: ParameterEncoding.JSON, headers: nil)
            .response { (request, response, result, error) -> Void in
                //                print("\nrepsone", response, "\nrequest", request, "\nresult", result, "\nerror", error)
                //                print( JSON(data: result!))
                let ok = JSON(data: result!)
                self.data = ok
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itineraryCell", forIndexPath: indexPath) as! ItineraryTableViewCell
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: ItineraryTableViewCell, forRowAtIndexPath: NSIndexPath) {
        
        cell.initialize(data["airline"].string!, airlineName: data["airline_name"].string!, departTime: formatDate(data["departure_date"].string!), departAirport: data["origin"].string!, numberOfStops: "→", landingTime: formatDate(data["return_date"].string!), landingAirport: data["destination"].string!,  flightTime: "1d", hotelImage: "aa", hotelName: data["hotel"].string!, hotelRating: CGFloat(data["hotel_rating"].float!), totalCost: data["total_cost"].string!)
        
    }
    
    func formatDate(dateString : String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        let date = dateFormatter.dateFromString(dateString)
        print(date)
 
        let formattedString = "\(date?.dayMonthYear.1)/\(date?.dayMonthYear.0)"
        
        return formattedString
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
