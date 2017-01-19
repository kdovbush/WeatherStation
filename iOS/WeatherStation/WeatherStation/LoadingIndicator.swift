//
//  LoadingIndicator.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/19/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadingIndicator: UIView {
    
    // MARK: - Private properties
    
    fileprivate var indicatorView: NVActivityIndicatorView!
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black
        alpha = 0
        
        let indicatorFrame = CGRect(x: frame.width / 2, y: frame.height / 2, width: 50, height: 50)
        indicatorView = NVActivityIndicatorView(frame: indicatorFrame, type: .ballSpinFadeLoader, color: UIColor.white, padding: nil)
        indicatorView.center = self.center
        indicatorView.startAnimating()
        addSubview(indicatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
