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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var onlineIconImageView: UIImageView!
    
    // MARK: - Properties
    
    var station: Station? {
        didSet {
            if let station = station {
                nameLabel.text = station.name
                addressLabel.text = station.address
                onlineIconImageView.image = station.available ? UIImage(named: "online") : UIImage(named: "offline")
            }
        }
    }
    
}
