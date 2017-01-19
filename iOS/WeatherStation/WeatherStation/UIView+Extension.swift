//
//  UIView+Extension.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/19/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    /**
     Fade in a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeIn(duration: TimeInterval = 0.3, alpha: CGFloat = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
        })
    }
    
    /**
     Fade out a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeOut(with duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }

}
