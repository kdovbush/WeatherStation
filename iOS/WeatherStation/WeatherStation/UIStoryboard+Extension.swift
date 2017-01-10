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
    
    class var mainTabBarController: MainTabBarController? {
        return main.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController
    }
    
    class var newStationNavigationController: UINavigationController? {
        return main.instantiateViewController(withIdentifier: "NewStationNavigationController") as? UINavigationController
    }
    
    class var stationViewController: StationViewController? {
        return main.instantiateViewController(withIdentifier: "StationViewController") as? StationViewController
    }
    
}

