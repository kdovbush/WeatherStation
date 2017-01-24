//
//  SettingsTableViewController.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 10/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit
import CoreData

enum SettingsType {
    case station
    case detector
}

class SettingsTableViewController: UITableViewController {

    // MARK: - Public properties
    
    var type: SettingsType = .station
    var object: NSManagedObject?
    
    // MARK: - Private properties
    
    var delegate: NewStationDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch object {
        case let detector as Detector:
            nameTextField.text = detector.name
            addressTextField.text = detector.address
            addressTextField.isEnabled = false
            navigationItem.title = "Detector Settings"
            break
        case let station as Station:
            nameTextField.text = station.name
            addressTextField.text = station.address
            navigationItem.title = "Station Settings"
            break
        default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    // MARK: - User interactions
    
    @IBAction func actionSave(_ sender: UIBarButtonItem) {
        if isEmptyFields() {
            presentRequiredFieldsAlert()
        } else {
            editObject()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func actionCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionClearData(_ sender: UIBarButtonItem) {
        switch object {
        case let detector as Detector:
            NetworkManager.shared.cleanMeasurements(for: detector.station, detector: detector, completion: { (completion) in
                if completion {
                    print("Cleaned data for detector: \(detector.name) in station \(detector.station.name)")
                }
            })
            break
        case let station as Station:
            NetworkManager.shared.cleanMeasurements(for: station, completion: { (completion) in
                if completion {
                    print("Cleaned data for station: \(station.name)")
                }
            })
        default:
            break
        }
    }
    
    // MARK: - Helper methods
    
    func editObject() {
        switch object {
        case let detector as Detector:
            detector.name = nameTextField.text
            detector.address = addressTextField.text
        case let station as Station:
            station.name = nameTextField.text
            station.address = addressTextField.text
        default:
            break
        }
        // TODO: Change
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StationSettingsDidChangeNotification"), object: nil, userInfo: ["object":object])
    }
    
    func isEmptyFields() -> Bool {
        return nameTextField.text == "" || addressTextField.text == ""
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        // If section with `Clear button`
        if section == numberOfSections(in: tableView) - 1 {
            let text = "This option will clear all stored measurements for"
            switch object {
            case let detector as Detector:
                return "\(text) '\(detector.name ?? "")' detector"
            case let station as Station:
                return "\(text) '\(station.name ?? "")' station"
            default:
                break
            }
        }
        return nil
    }
    
}






