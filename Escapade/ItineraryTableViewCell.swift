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
    @IBOutlet weak var flightCost: UILabel!
    
    
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var hotelRating: HCSStarRatingView!
    @IBOutlet weak var hotelCost: UILabel!
    
    func initialize( airlineImage: String, airlineName: String,
        departTime: String, departAirport: String, numberOfStops: String, landingTime: String, landingAirport: String,
        flightTime: String, flightCost: String, hotelImage: String, hotelName: String, hotelRating: CGFloat, hotelCost: String)
    {
        self.airlineImage.image = UIImage(named: airlineImage)
        self.airlineName.text = airlineName
        self.departTime.text = departTime
        self.departAirport.text = departAirport
        self.numberOfStops.text = numberOfStops
        self.landingTime.text = landingTime
        self.landingAirport.text = landingAirport
        self.flightTime.text = flightTime
        self.flightCost.text = flightCost
        self.hotelImage.image = UIImage(named: hotelImage)
        self.hotelName.text = hotelName
        self.hotelRating.value = hotelRating
        self.hotelCost.text = hotelCost
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
