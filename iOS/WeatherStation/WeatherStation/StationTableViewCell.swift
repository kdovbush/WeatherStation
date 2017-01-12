//
//  StationTableViewCell.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 02/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationAddressLabel: UILabel!
    @IBOutlet weak var onlineIconImageView: UIImageView!
    
    // MARK: - Properties
    
    var station: Station? {
        didSet {
            if let station = station {
                stationNameLabel.text = station.name
                stationAddressLabel.text = station.address
                onlineIconImageView.image = station.available ? UIImage(named: "online") : UIImage(named: "offline")
            }
        }
    }
    
}
