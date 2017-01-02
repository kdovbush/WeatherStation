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
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Configuration methods
    
    func configureCell() {
        if let station = station {
            stationNameLabel.text = station.name
            stationAddressLabel.text = station.address
            onlineIconImageView.image = station.available ? UIImage(named: "online") : UIImage(named: "offline")
        }
    }
    
}
