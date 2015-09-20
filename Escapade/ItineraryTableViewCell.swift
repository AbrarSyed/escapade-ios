//
//  ItineraryTableViewCell.swift
//  Escapade
//
//  Created by Mosab Elagha on 9/19/15.
//  Copyright © 2015 Mosab Elagha. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ItineraryTableViewCell: UITableViewCell {

    @IBOutlet weak var airlineImage: UIImageView!
    @IBOutlet weak var airlineName: UILabel!
    
    
    @IBOutlet weak var departTime: UILabel!
    @IBOutlet weak var departAirport: UILabel!
    @IBOutlet weak var numberOfStops: UILabel!
    @IBOutlet weak var landingTime: UILabel!
    @IBOutlet weak var landingAirport: UILabel!
    
    @IBOutlet weak var flightTime: UILabel!
    
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var hotelRating: HCSStarRatingView!
    
    @IBOutlet weak var totalCost: UILabel!

    
    func initialize( airlineImage: String, airlineName: String,
        departTime: String, departAirport: String, numberOfStops: String, landingTime: String, landingAirport: String,
        flightTime: String, hotelImage: String, hotelName: String, hotelRating: CGFloat, totalCost: String)
    {
        let url = NSURL(string: "http://a2.r9cdn.net/res/images/air/2x/\(airlineImage).png")
        self.airlineImage.image = UIImage(data: NSData(contentsOfURL: url!)!)
        self.airlineName.text = airlineName
        self.departTime.text = departTime
        self.departAirport.text = departAirport
        self.numberOfStops.text = numberOfStops
        self.landingTime.text = landingTime
        self.landingAirport.text = landingAirport
        self.flightTime.text = flightTime
        self.hotelImage.image = UIImage(named: hotelImage)
        self.hotelName.text = hotelName
        self.hotelRating.value = hotelRating
        self.totalCost.text = totalCost
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
