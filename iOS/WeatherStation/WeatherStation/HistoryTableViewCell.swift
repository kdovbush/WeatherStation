//
//  HistoryTableViewCell.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 10/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet public weak var hourLabel: UILabel!
    @IBOutlet public weak var dateLabel: UILabel!
    @IBOutlet public weak var yearLabel: UILabel!
    
    @IBOutlet public weak var temperatureLabel: UILabel!
    @IBOutlet public weak var humidityLabel: UILabel!
    @IBOutlet public weak var heatIndexLabel: UILabel!
    @IBOutlet public weak var rainLabel: UILabel!
    
    // MARK: - Public properties
    
    var measurement: Measurements? {
        didSet {
            if let measurement = measurement {
                temperatureLabel.text = String(describing: measurement.temperature)
                humidityLabel.text = String(describing: measurement.humidity)
                heatIndexLabel.text = String(describing: measurement.heatIndex)
                rainLabel.text = String(describing: measurement.rainAnalog)
                configureDateLabels(date: measurement.createdAt as Date)
            }
        }
    }
    
    // MARK: - Configuration methods
    
    func configureDateLabels(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        hourLabel.text = formatter.string(from: date)
        formatter.dateFormat = "MM.dd"
        dateLabel.text = formatter.string(from: date)
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
    }
    
}
