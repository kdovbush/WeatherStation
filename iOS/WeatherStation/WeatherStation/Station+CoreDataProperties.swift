//
//  Station+CoreDataProperties.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 23/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import Foundation
import CoreData


extension Station {

    @NSManaged public var id: Int16
    @NSManaged public var createdAt: NSDate
    @NSManaged public var name: String?
    @NSManaged public var address: String?
    @NSManaged public var available: Bool
    @NSManaged public var detectors: NSSet?

}

// MARK: Generated accessors for detectors
extension Station {

    @objc(addDetectorsObject:)
    @NSManaged public func addToDetectors(_ value: Detector)

    @objc(removeDetectorsObject:)
    @NSManaged public func removeFromDetectors(_ value: Detector)

    @objc(addDetectors:)
    @NSManaged public func addToDetectors(_ values: NSSet)

    @objc(removeDetectors:)
    @NSManaged public func removeFromDetectors(_ values: NSSet)

}
