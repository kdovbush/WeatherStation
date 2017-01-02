//
//  StationViewController.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 02/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit

class StationViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    // MARK: - Public properties
    
    var station: Station?
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = station?.name
    }
    
    // MARK: - User interactions
    
    @IBAction func actionShowSettings(_ sender: UIBarButtonItem) {
        print("Show settings")
    }
    
    // MARK: - Configuration methods
    

}
