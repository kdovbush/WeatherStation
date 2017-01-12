//
//  UIColor+Extension.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 12/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String) {
        var rgbValue: UInt32 = 0
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1
        scanner.scanHexInt32(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xff0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0xff00) >> 8) / 255.0
        let blue = CGFloat((rgbValue & 0xff) >> 0) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
}
