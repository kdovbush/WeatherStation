//
//  NSDate+Extension.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/17/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import Foundation

extension NSDate: Comparable {
    
}

public func <(left: NSDate, right: NSDate) -> Bool {
    return left.compare(right as Date) == ComparisonResult.orderedAscending
}

public func >(left: NSDate, right: NSDate) -> Bool {
    return left.compare(right as Date) == ComparisonResult.orderedDescending
}
