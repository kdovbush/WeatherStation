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
        return getAllMeasurements().flatMap({ return $0.temperature })
    }
    
    var humidities: [Double] {
        return getAllMeasurements().flatMap({ return $0.humidity })
    }
    
    var heatIndexes: [Double] {
        return getAllMeasurements().flatMap({ return $0.heatIndex })
    }
    
    var rainAnalogs: [Double] {
        return getAllMeasurements().flatMap({ return $0.rainAnalog })
    }
    
    var lastMeasurement: Measurements? {
        return getAllMeasurements().last
    }

    // MARK: - Class methods
    
    class func getAll() -> [Station] {
        return Station.mr_findAll(in: context) as! [Station]
    }
    
    // MARK: - Methods
    
    func getAllMeasurements() -> [Measurements] {
        if let measurements = measurements?.allObjects as? [Measurements] {
            return measurements.sorted{ $0.createdAt < $1.createdAt }
        }
        return []
    }
    
    func getDateStrings() -> [String] {
        return getAllMeasurements().flatMap({
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: $0.createdAt as Date)
        })
    }
    
}
