//
//  DetectorTableViewCell.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 23/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit

class DetectorTableViewCell: UITableViewCell {

    // MARK: - Outlest
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    // MARK: - Properties
    
    var detector: Detector? {
        didSet {
            if let detector = detector {
                nameLabel.text = detector.name
                addressLabel.text = detector.address
            }
        }
    }

}
