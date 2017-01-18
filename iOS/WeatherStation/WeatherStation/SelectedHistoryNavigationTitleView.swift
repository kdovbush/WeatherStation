//
//  SelectedHistoryNavigationTitleView.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/18/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit

class SelectedHistoryNavigationTitleView: UIView {

    // MARK: - Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: - Initialization
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SelectedHistoryNavigationTitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
