//
//  Detector+Extension.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 23/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord
import SwiftyJSON

extension Detector {
    
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
    
    class func getAll() -> [Detector] {
        return Detector.mr_findAll(in: context) as! [Detector]
    }
    
    // MARK: - Methods
    
    func getDateStrings() -> [String] {
        return allMeasurements.flatMap({
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: $0.createdAt as Date)
        })
    }
    
    // MARK: - Parser
    
    class func parseDetectors(data: Data, for station: Station) -> [Detector] {
        let json = JSON(data: data)
        
        var result: [Detector] = []
        
        if let detectors = json["detectors"].array {
            for detector in detectors {
                if let detector = parseDetector(json: detector, for: station) {
                    result.append(detector)
                }
            }
        }
        return result
    }
    
    class func parseDetector(json: JSON, for station: Station) -> Detector? {
        if let id = json["id"].int, let name = json["name"].string, let address = json["address"].string {
            
            var detector = Detector.mr_findFirst(byAttribute: "detectorId", withValue: id, in: NSManagedObject.context)
            
            if detector == nil {
                detector = Detector.mr_createEntity()
            }
            
            detector?.detectorId = Int16(id)
            detector?.name = name
            detector?.address = address
            detector?.station = station
            
            detector?.save()
            
            return detector
        }
        
        return nil
    }
    
    class func removeInvalidDetectors(detectorsJson: [Detector]) {
        guard let localDetectors = Detector.mr_findAll(in: NSManagedObject.context) as? [Detector] else { return }
        let localDetectorsIds = localDetectors.map({$0.detectorId as Int16})
        
        let validDetectors = detectorsJson.map({$0.detectorId as Int16})
        
        let invalidDetectorsIds = localDetectorsIds.filter({!validDetectors.contains($0)})
        
        Detector.mr_deleteAll(matching: NSPredicate(format: "detectorId in %@", invalidDetectorsIds), in: NSManagedObject.context)
    }
    
}


