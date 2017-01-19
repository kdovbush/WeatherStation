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
            
            let save: (Station) -> Void = { station in
                station.save()
                self.delegate?.stationAdded(station: station)
                self.dismiss(animated: true, completion: nil)
            }
            
            LoadingIndicator.present()
            
            NetworkManager.shared.check(adress: stationAddress, completion: { (connected) in
                LoadingIndicator.hide()
                
                if let station = self.createStation() {
                    if connected {
                        save(station)
                    } else {
                        self.presentConnectionErrorAlert(addAnywayAction: {
                            save(station)
                        }, cancelAction: {
                            station.remove()
                            self.stationAddressTextField.becomeFirstResponder()
                        })
                    }
                } else {
                    self.presentCantCreateStation()
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
    
    func createStation() -> Station? {
        if let station = Station.mr_createEntity() {
            station.name = stationNameTextField.text
            station.address = stationAddressTextField.text
            station.available = Bool(arc4random_uniform(2)) // Change to false and use response of request
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
                measurement.humidity = Double(arc4random_uniform(100))
                measurement.heatIndex = Double(arc4random_uniform(140))
                measurement.rainAnalog = Double(arc4random_uniform(1000))
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
