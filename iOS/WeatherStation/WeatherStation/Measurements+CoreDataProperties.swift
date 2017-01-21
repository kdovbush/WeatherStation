//
//  Measurements+CoreDataProperties.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/21/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import Foundation
import CoreData


extension Measurements {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Measurements> {
        return NSFetchRequest<Measurements>(entityName: "Measurements");
    }

    @NSManaged public var createdAt: NSDate
    @NSManaged public var heatIndex: Double
    @NSManaged public var humidity: Int32
    @NSManaged public var rainAnalog: Int32
    @NSManaged public var rainDigital: Bool
    @NSManaged public var temperature: Double
    @NSManaged public var station: Station?

}
