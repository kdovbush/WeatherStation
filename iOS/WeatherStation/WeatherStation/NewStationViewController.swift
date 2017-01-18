//
//  NewStationViewController.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 02/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit

protocol NewStationDelegate {
    func stationAdded(station: Station)
}

class NewStationViewController: UITableViewController {

    // MARK: - Properties
    
    var delegate: NewStationDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var stationNameTextField: UITextField!
    @IBOutlet weak var stationAddressTextField: UITextField!
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }

    // MARK: - User interactions
    
    @IBAction func actionSave(_ sender: UIBarButtonItem) {
        if isEmptyFields() {
            let alertView = UIAlertController(title: "Required Fields Missing", message: "Name and Address can't be empty", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alertView, animated: true, completion: nil)
        } else {
            let station = createStation()
            delegate?.stationAdded(station: station)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func actionCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Configuration methods
    
    func configureTextFields() {
        stationNameTextField.delegate = self
        stationAddressTextField.delegate = self
    }
    
    // MARK: - Helper methods
    
    func createStation() -> Station {
        let station = Station.mr_createEntity()!
        station.name = stationNameTextField.text
        station.address = stationAddressTextField.text
        station.available = Bool(arc4random_uniform(2)) // Change to false and use response of request
        station.createdAt = NSDate()
        station.temperatureUnits = 0
        
        // Should be replaced with real data
        for _ in 0...20 {
            let measurement = Measurements.mr_createEntity()!
            measurement.createdAt = NSDate()
            
            let lowerValue = -20
            let upperValue = 25
            let result = Int(arc4random_uniform(UInt32(upperValue - lowerValue + 1))) + lowerValue
            
            measurement.temperature = Double(result)
            measurement.humidity = Double(arc4random_uniform(100))
            measurement.heatIndex = Double(arc4random_uniform(140))
            measurement.rainAnalog = Double(arc4random_uniform(1000))
            measurement.rainDigital = Bool(arc4random_uniform(1))
            
            station.addToMeasurements(measurement)
        }
        
        station.save()
            
        return station
    }
    
    func isEmptyFields() -> Bool {
        return stationNameTextField.text == "" || stationAddressTextField.text == ""
    }
    
}

extension NewStationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == stationNameTextField {
            stationAddressTextField.becomeFirstResponder()
        } else if textField == stationAddressTextField {
            stationAddressTextField.resignFirstResponder()
        }
        return true
    }
    
}
