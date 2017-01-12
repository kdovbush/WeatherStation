//
//  Station+CoreDataProperties.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 12/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import Foundation
import CoreData


extension Station {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Station> {
        return NSFetchRequest<Station>(entityName: "Station");
    }

    @NSManaged public var address: String?
    @NSManaged public var available: Bool
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var temperatureUnits: Int16
    @NSManaged public var measurements: NSSet?

}

// MARK: Generated accessors for measurements
extension Station {

    @objc(addMeasurementsObject:)
    @NSManaged public func addToMeasurements(_ value: Measurements)

    @objc(removeMeasurementsObject:)
    @NSManaged public func removeFromMeasurements(_ value: Measurements)

    @objc(addMeasurements:)
    @NSManaged public func addToMeasurements(_ values: NSSet)

    @objc(removeMeasurements:)
    @NSManaged public func removeFromMeasurements(_ values: NSSet)

}
