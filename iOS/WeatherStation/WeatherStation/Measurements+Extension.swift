//
//  Measurements+Extension.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/17/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord
import SwiftyJSON

extension Measurements {
    
    class func parseMeasurements(data: Data, for detector: Detector) -> [Measurements] {
        let json = JSON(data: data)
        
        var result: [Measurements] = []
        
        if let measurements = json["measurements"].array {
            for measurement in measurements {
                if let measurement = parseMeasurement(json: measurement, for: detector) {
                    result.append(measurement)
                }
            }
        }
        return result
    }
    
    class func parseMeasurement(json: JSON, for detector: Detector) -> Measurements? {
        if let timestamp = json["createdAt"].double, let temperature = json["temperature"].double,
            let humidity = json["humidity"].double, let rainAnalog = json["rainAnalog"].double,
            let rainDigital = json["rainDigital"].int, let heatIndex = json["heatIndex"].double {
            
            let createdAt = NSDate(timeIntervalSince1970: timestamp)
            
            var measurement = Measurements.mr_findFirst(byAttribute: "createdAt", withValue: createdAt, in: NSManagedObject.context)
            
            if measurement == nil {
                measurement = Measurements.mr_createEntity()
            }
            
            measurement?.createdAt = createdAt
            measurement?.temperature = temperature.roundTo(places: 1)
            measurement?.humidity = Int16(humidity)
            measurement?.heatIndex = heatIndex > 0 ? heatIndex.roundTo(places: 1) : 0.0
            measurement?.rainAnalog = Int16(rainAnalog)
            measurement?.rainDigital = Bool(rainDigital)
            measurement?.detector = detector
            
            measurement?.save()
            
            return measurement
        }
        
        return nil
    }
    
}
