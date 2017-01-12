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
            tableView.contentInset = UIEdgeInsets(top: -10, left: 0, bottom: 60, right: 0)
            configureView(for: station)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.backBarButtonItem?.title = "History"
        navigationController?.navigationBar.backItem?.title = "History"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
    // MARK: - User interactions

    @IBAction func actionHeatIndexInfo(_ sender: UIButton) {
        print("ℹ️ heat index info")
    }
    
    // MARK: - Configuration methods
    
    func configureView(for object: NSManagedObject?) {
        switch object {
        case let object as Station:
            configureHeatIndexLabels(for: 100)
        case let object as Measurements:
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm dd.MM.yyy"
            navigationItem.title = formatter.string(from: object.createdAt as Date)
            
            
            temperatureLabel.text = String(describing: object.temperature)
            
            humidityLabel.text = String(describing: object.humidity)
            
            heatIndexLabel.text = String(describing: object.heatIndex)
            
            moistureLevelLabel.text = String(describing: object.rainAnalog)
            
            configureHeatIndexLabels(for: object.heatIndex)
        default:
            break
        }
    }
    
    func configureHeatIndexLabels(for index: Double) {
        switch index {
        case 0...90:
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
