//
//  Detector+CoreDataProperties.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 23/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Detector {

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var address: String?
    @NSManaged public var detectorId: Int16
    @NSManaged public var station: Station?
    @NSManaged public var measurements: NSSet?

}

// MARK: Generated accessors for measurements
extension Detector {

    @objc(addMeasurementsObject:)
    @NSManaged public func addToMeasurements(_ value: Measurements)

    @objc(removeMeasurementsObject:)
    @NSManaged public func removeFromMeasurements(_ value: Measurements)

    @objc(addMeasurements:)
    @NSManaged public func addToMeasurements(_ values: NSSet)

    @objc(removeMeasurements:)
    @NSManaged public func removeFromMeasurements(_ values: NSSet)

}
