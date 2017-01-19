//
//  LoadingIndicatorManager.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/19/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit

class LoadingIndicatorManager: NSObject {

    // MARK: - Static properties
    
    static let shared = LoadingIndicatorManager()
    
    // MARK: - Properties
    
    var loadingIndicator: LoadingIndicator?
    
    // MARK: - Methods
    
    func present() {
        if let window = UIApplication.shared.keyWindow {
            loadingIndicator = LoadingIndicator(frame: window.frame)
            if let loadingIndicator = loadingIndicator {
                window.addSubview(loadingIndicator)
                loadingIndicator.fadeIn(duration: 0.3, alpha: 0.4)
            }
        }
    }
    
    func hide() {
        loadingIndicator?.fadeOut()
        loadingIndicator?.removeFromSuperview()
    }
    
}
