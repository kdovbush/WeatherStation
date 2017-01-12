//
//  SettingsTableViewController.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 10/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit

enum TemperatureUnits {
    case celsius
    case fahrenheit
}

class SettingsTableViewController: UITableViewController {

    // MARK: - Public properties
    
    var station: Station?
    
    // MARK: - Private properties
    
    var delegate: NewStationDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var temperatureUnitsSegmentedControl: UISegmentedControl!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = station?.name
        addressTextField.text = station?.address
    }
    
    // MARK: - User interactions
    
    @IBAction func actionSave(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
