//
//  LoadingIndicatorManager.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/19/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadingIndicator: NSObject {
    
    // MARK: - Static methods
    
    static func present() {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(size: CGSize(width: 35, height: 35), message: "Connecting", type: .ballSpinFadeLoader, color: UIColor(hex: "#ecf0f1"), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: 1))
    }
    
    static func hide() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
}
