//
//  SettingsTableViewController.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 10/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit

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
            editStation()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func actionCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper methods
    
    func editStation() {
        if let station = station {
            station.name = nameTextField.text
            station.address = addressTextField.text
            station.temperatureUnits = Int16(temperatureUnitsSegmentedControl.selectedSegmentIndex)
            station.save()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StationSettingsDidChangeNotification"), object: nil, userInfo: ["station":station])
        }
    }
    
    func isEmptyFields() -> Bool {
        return nameTextField.text == "" || addressTextField.text == ""
    }
    
}
