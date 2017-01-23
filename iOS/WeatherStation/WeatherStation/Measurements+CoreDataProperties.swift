//
//  Measurements+CoreDataProperties.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 23/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import Foundation
import CoreData


extension Measurements {

    @NSManaged public var id: Int16
    @NSManaged public var createdAt: NSDate
    @NSManaged public var humidity: Int16
    @NSManaged public var temperature: Double
    @NSManaged public var heatIndex: Double
    @NSManaged public var rainAnalog: Int16
    @NSManaged public var rainDigital: Bool
    @NSManaged public var detector: Detector?

}
