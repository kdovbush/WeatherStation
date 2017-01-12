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
    
    class func getAll() -> [Station] {
        return Station.mr_findAll(in: context) as! [Station]
    }
    
}
