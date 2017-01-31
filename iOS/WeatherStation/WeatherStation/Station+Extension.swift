//
//  Station+Extension.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 12/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord

extension Station {
    
    // MARK: - Properties
    
    var allDetectors: [Detector] {
        if let detectors = detectors?.allObjects as? [Detector] {
            return detectors.sorted{ $0.id < $1.id }
        }
        return []
    }
    
    // MARK: - Class methods
    
    class func getAll() -> [Station] {
        return Station.mr_findAll(in: context) as! [Station]
    }
    
    class func removeAll() -> Bool {
        return Station.mr_truncateAll()
    }
    
    class func getStation(with address: String) -> Station? {
        return getAll().filter({$0.address == address}).first
    }
    
}
