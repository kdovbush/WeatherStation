//
//  StationViewController.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 02/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit
import CoreData

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
    
    var detector: Detector?
    var measurement: Measurements? // If going from history screen
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if measurement != nil {
            tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
            configureView(for: measurement)
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
            configureView(for: detector)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(detectorDidChange(notification:)), name: NSNotification.Name(rawValue: "DetectorDidChangeNotification"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        case let detector as Detector:
            navigationItem.title = detector.name
            
            guard let lastMeasurement = detector.allMeasurements.last else { return }
            temperatureLabel.text = String(lastMeasurement.temperature) + "°C"
            humidityLabel.text = String(lastMeasurement.humidity) + "%"
            moistureLevelLabel.text = String(lastMeasurement.rainAnalog)
            rainImageView.image = lastMeasurement.rainDigital ? UIImage(named: "noRain") : UIImage(named: "rain")
            configureHeatIndexLabels(for: lastMeasurement.heatIndex)

            if let minTemperature = detector.temperatures.min(), let maxTemperature = detector.temperatures.max() {
                temperatureMinLabel.text = String(minTemperature) + "°C"
                temperatureMaxLabel.text = String(maxTemperature) + "°C"
            }
            
            if let minHumidity = detector.humidities.min(), let maxHumidity = detector.humidities.max() {
                humidityMinLabel.text = String(Int(minHumidity)) + "%"
                humidityMaxLabel.text = String(Int(maxHumidity)) + "%"
            }
            
        case let measurements as Measurements:
            let formatter = DateFormatter()
            if let navigationView = SelectedHistoryNavigationTitleView.instanceFromNib() as? SelectedHistoryNavigationTitleView {
                formatter.dateFormat = "HH:mm"
                navigationView.timeLabel.text = formatter.string(from: measurements.createdAt as Date)
                formatter.dateFormat = "dd.MM.yyyy"
                navigationView.dateLabel.text = formatter.string(from: measurements.createdAt as Date)
                navigationItem.titleView = navigationView
            } else {
                formatter.dateFormat = "HH:mm dd.MM.yyy"
                navigationItem.title = formatter.string(from: measurements.createdAt as Date)
            }
            
            if let detector = detector {
                temperatureLabel.text = String(measurements.temperature) + "°C"
                humidityLabel.text = String(measurements.humidity) + "%"
                moistureLevelLabel.text = String(measurements.rainAnalog)
                rainImageView.image = measurements.rainDigital ? UIImage(named: "noRain") : UIImage(named: "rain")
                configureHeatIndexLabels(for: measurements.heatIndex)
                
                if let minTemperature = detector.temperatures.min(), let maxTemperature = detector.temperatures.max() {
                    temperatureMinLabel.text = String(minTemperature) + "°C"
                    temperatureMaxLabel.text = String(maxTemperature) + "°C"
                }
                
                if let minHumidity = detector.humidities.min(), let maxHumidity = detector.humidities.max() {
                    humidityMinLabel.text = String(Int(minHumidity)) + "%"
                    humidityMaxLabel.text = String(Int(maxHumidity)) + "%"
                }
            }
        default:
            break
        }
    }
    
    func configureHeatIndexLabels(for index: Double) {
        heatIndexLabel.text = String(index)

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
    
    // MARK: - Notifications
    
    func detectorDidChange(notification: Notification) {
        // Reload indicatorsData
        if detector != nil, measurement == nil {
            configureView(for: detector)
        }
    }

}
