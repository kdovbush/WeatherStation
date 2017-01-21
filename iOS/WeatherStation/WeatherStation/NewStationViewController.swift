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
        
        // Should be removed
        stationNameTextField.text = "Home"
        stationAddressTextField.text = "192.168.1.109"
        
        configureTextFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        stationNameTextField.becomeFirstResponder()
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
            view.endEditing(true)
            
            guard let stationAddress = stationAddressTextField.text else { return }

            LoadingIndicator.present()
            
            NetworkManager.shared.check(address: stationAddress, completion: { (connected) in
                LoadingIndicator.hide()
                
                if connected {
                    self.saveStation(available: true)
                } else {
                    self.presentConnectionErrorAlert(addAnywayAction: {
                        self.saveStation(available: false)
                    }, cancelAction: {
                        self.stationAddressTextField.becomeFirstResponder()
                    })
                }
            })
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
    
    func saveStation(available: Bool) {
        if let station = self.createStation() {
            station.available = available
            station.save()
            
            //NetworkManager.shared.getMeasurements(for: station, completion: { result in })
            
            self.delegate?.stationAdded(station: station)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func createStation() -> Station? {
        if let station = Station.mr_createEntity() {
            station.name = stationNameTextField.text
            station.address = stationAddressTextField.text
            station.available = false
            station.createdAt = NSDate()
            station.temperatureUnits = 0
            
            // Should be replaced with real data
            for _ in 0...200 {
                let measurement = Measurements.mr_createEntity()!
                measurement.createdAt = NSDate().random
                
                let lowerValue = -20
                let upperValue = 25
                let result = Int(arc4random_uniform(UInt32(upperValue - lowerValue + 1))) + lowerValue
                
                measurement.temperature = Double(result)
                measurement.humidity = Int32(arc4random_uniform(100))
                measurement.heatIndex = Double(arc4random_uniform(140))
                measurement.rainAnalog = Int32(arc4random_uniform(1000))
                measurement.rainDigital = measurement.rainAnalog > 500
                
                station.addToMeasurements(measurement)
            }
            
            return station
        }
        
        return nil
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
