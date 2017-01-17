//
//  Int+Extension.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/17/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import Foundation

extension Bool {
    
    init<T : Integer>(_ integer: T) {
        if integer == 0 {
            self.init(false)
        } else {
            self.init(true)
        }
    }
    
}
