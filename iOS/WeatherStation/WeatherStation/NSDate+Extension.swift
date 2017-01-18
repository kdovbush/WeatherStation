//
//  NSDate+Extension.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/17/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import Foundation

extension NSDate: Comparable {

    var random: NSDate {
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        components.month = Int(arc4random_uniform(12))
 
        let range = calendar.range(of: .day, in: .month, for: calendar.date(from: components)!)
        
        components.day = Int(arc4random_uniform(UInt32((range?.upperBound)!)))
        components.hour = Int(arc4random_uniform(24))
        components.minute = Int(arc4random_uniform(60))
        components.second = 0
        components.timeZone = TimeZone(identifier: "GMT")
        
        let nsDate = calendar.date(from: components)! as NSDate
        
        return nsDate
    }
    
    
}

public func <(left: NSDate, right: NSDate) -> Bool {
    return left.compare(right as Date) == ComparisonResult.orderedAscending
}

public func >(left: NSDate, right: NSDate) -> Bool {
    return left.compare(right as Date) == ComparisonResult.orderedDescending
}
