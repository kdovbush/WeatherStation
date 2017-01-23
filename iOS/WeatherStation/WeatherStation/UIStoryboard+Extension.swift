//
//  UIStoryboard+Extension.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 02/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    class var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    // MARK: - Stations
    
    class var newStationNavigationController: UINavigationController? {
        return main.instantiateViewController(withIdentifier: "NewStationNavigationController") as? UINavigationController
    }
    
    // MARK: - Detectors
    
    class var detectorsViewController: DetectorsViewController? {
        return main.instantiateViewController(withIdentifier: "DetectorsViewController") as? DetectorsViewController
    }
    
    // MARK: - Detector
    
    class var wrapperViewController: WrapperViewController? {
        return main.instantiateViewController(withIdentifier: "WrapperViewController") as? WrapperViewController
    }
    
    class var indicatorsViewController: IndicatorsViewController? {
        return main.instantiateViewController(withIdentifier: "IndicatorsViewController") as? IndicatorsViewController
    }
    
    class var chartsViewController: ChartsViewController? {
        return main.instantiateViewController(withIdentifier: "ChartsViewController") as? ChartsViewController
    }
    
    class var historyViewController: HistoryViewController? {
        return main.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController
    }
    
    class var settingsNavigationController: UINavigationController? {
        return main.instantiateViewController(withIdentifier: "SettingsNavigationController") as? UINavigationController
    }
    
    class var heatIndexInfoViewController: HeatIndexInfoViewController? {
        return main.instantiateViewController(withIdentifier: "HeatIndexInfoViewController") as? HeatIndexInfoViewController
    }
    
}

