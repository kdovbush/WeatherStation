//
//  StationViewController.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 02/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit
import CoreData

enum HeatIndexClassification {
    case caution
    case extremeCaution
    case danger
    case extremeDanger
}

class IndicatorsViewController: UITableViewController {

    // MARK: - Outlets
    
    // Temperature
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureMinLabel: UILabel!
    @IBOutlet weak var temperatureMaxLabel: UILabel!
    
    // Humidity
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var humidityMinLabel: UILabel!
    @IBOutlet weak var humidityMaxLabel: UILabel!
    
    // Heat index
    @IBOutlet weak var heatIndexLabel: UILabel!
    @IBOutlet weak var heatIndexAlertLabel: UILabel!
    @IBOutlet weak var heatIndexInfoLabel: UILabel!
    
    // Rain
    @IBOutlet weak var moistureLevelLabel: UILabel!
    @IBOutlet weak var rainImageView: UIImageView!
    
    // MARK: - Public properties
    
    var station: Station?
    // If going from history screen
    var measurement: Measurements?
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if measurement != nil {
            tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
            configureView(for: measurement)
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
            configureView(for: station)
        }
        
    }
    
    // MARK: - User interactions

    @IBAction func actionHeatIndexInfo(_ sender: UIButton) {
        if let heatIndexInfoViewController = UIStoryboard.heatIndexInfoViewController {
            navigationController?.pushViewController(heatIndexInfoViewController, animated: true)
        }
    }
    
    // MARK: - Configuration methods
    
    func configureView(for object: NSManagedObject?) {
        switch object {
        case let object as Station:
            navigationItem.title = station?.name
            
            temperatureLabel.text = String(object.lastMeasurement!.temperature)
            temperatureMinLabel.text = String(describing: object.temperatures.min()!)
            temperatureMaxLabel.text = String(describing: object.temperatures.max()!)
            
            humidityLabel.text = String(object.lastMeasurement!.humidity)
            humidityMinLabel.text = String(describing: object.humidities.min()!)
            humidityMaxLabel.text = String(describing: object.humidities.max()!)
            
            moistureLevelLabel.text = String(object.rainAnalogs.last!)
            
            heatIndexLabel.text = String(object.heatIndexes.last!)
            configureHeatIndexLabels(for: object.heatIndexes.last!)
        case let object as Measurements:
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm dd.MM.yyy"
            navigationItem.title = formatter.string(from: object.createdAt as Date)
            
            temperatureLabel.text = String(object.temperature)
            temperatureMinLabel.text = String(station!.temperatures.min()!)
            temperatureMaxLabel.text = String(station!.temperatures.max()!)
            
            humidityLabel.text = String(object.humidity)
            humidityMinLabel.text = String(station!.humidities.min()!)
            humidityMaxLabel.text = String(station!.humidities.max()!)
            
            moistureLevelLabel.text = String(object.rainAnalog)
            
            heatIndexLabel.text = String(object.heatIndex)
            configureHeatIndexLabels(for: object.heatIndex)
        default:
            break
        }
    }
    
    func configureHeatIndexLabels(for index: Double) {
        switch index {
        case 0 ... 79:
            heatIndexAlertLabel.textColor = UIColor(hex: "#2ecc71")
            heatIndexAlertLabel.text = "Normal"
            heatIndexInfoLabel.text = "Normal heat index"
        case 80...90:
            heatIndexAlertLabel.textColor = UIColor(hex: "#f1c40f")
            heatIndexAlertLabel.text = "Caution"
            heatIndexInfoLabel.text = "Fatigue possible with prolonged exposure and/or physical activity."
        case 91...103:
            heatIndexAlertLabel.textColor = UIColor(hex: "#e67e22")
            heatIndexAlertLabel.text = "Extreme Caution"
            heatIndexInfoLabel.text = "Heat stroke, heat cramps, or heat exhaustion possible with prolonged exposure and/or physical activity."
        case 104...124:
            heatIndexAlertLabel.textColor = UIColor(hex: "#d35400")
            heatIndexAlertLabel.text = "Danger"
            heatIndexInfoLabel.text = "Heat cramps or heat exhaustion likely, and heat stroke possible with prolonged exposure and/or physical activity."
        case 125...140:
            heatIndexAlertLabel.textColor = UIColor(hex: "#c0392b")
            heatIndexAlertLabel.text = "Extreme Danger"
            heatIndexInfoLabel.text = "Heat stroke highly likely."
        default:
            break
        }
    }

}
