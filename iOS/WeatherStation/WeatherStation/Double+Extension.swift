//
//  Double+extension.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 18/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import Foundation

extension Double {
    
    var celsius: Double {
        return 0.0
    }
    
    var fahrenheit: Double {
        return 0.0
    }
    
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    
}
