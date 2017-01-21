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
    
    var temperatures: [Double] {
        return allMeasurements.flatMap({ return $0.temperature })
    }
    
    var humidities: [Double] {
        return allMeasurements.flatMap({ return Double($0.humidity) })
    }
    
    var heatIndexes: [Double] {
        return allMeasurements.flatMap({ return $0.heatIndex })
    }
    
    var rainAnalogs: [Double] {
        return allMeasurements.flatMap({ return Double($0.rainAnalog) })
    }
    
    var allMeasurements: [Measurements] {
        if let measurements = measurements?.allObjects as? [Measurements] {
            return measurements.sorted{ $0.createdAt < $1.createdAt }
        }
        
        return []
    }
    
    var lastMeasurement: Measurements? {
        return allMeasurements.last
    }

    // MARK: - Class methods
    
    class func getAll() -> [Station] {
        return Station.mr_findAll(in: context) as! [Station]
    }
    
    // MARK: - Methods
    
    func getDateStrings() -> [String] {
        return allMeasurements.flatMap({
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: $0.createdAt as Date)
        })
    }
    
}
