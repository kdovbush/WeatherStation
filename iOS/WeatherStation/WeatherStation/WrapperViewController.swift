//
//  WrapperViewController.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/11/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit

class WrapperViewController: UIViewController {

    // MARK: - Public properties
    
    var station: Station?
    var pageMenu: CAPSPageMenu?
    
    // MARK: - Outlets
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    // MARK: - Viewcontroller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(stationSettingsDidChange(_:)), name: NSNotification.Name(rawValue: "StationSettingsDidChangeNotification"), object: nil)
        
        navigationItem.title = station?.name
        configurePageMenu()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notifications
    
    func stationSettingsDidChange(_ notification: Notification) {
        if let station = notification.userInfo?["station"] as? Station {
            navigationItem.title = station.name
        }
    }
   
    // MARK: - Helper methods
    
    func configurePageMenu() {
        
        // Initialize view controllers to display and place in array
        
        var controllerArray : [UIViewController] = []
        
        if let indicatorsViewController = UIStoryboard.indicatorsViewController {
            indicatorsViewController.title = "INDICATORS"
            indicatorsViewController.station = station
            controllerArray.append(indicatorsViewController)
        }
        
        if let chartsViewController = UIStoryboard.chartsViewController {
            chartsViewController.title = "CHARTS"
            chartsViewController.station = station
            controllerArray.append(chartsViewController)
        }
        
        if let historyViewController = UIStoryboard.historyViewController {
            historyViewController.title = "HISTORY"
            historyViewController.station = station
            controllerArray.append(historyViewController)
        }
        
        // Customize menu
        
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectedMenuItemLabelColor(UIColor.black),
            .selectionIndicatorColor(UIColor.black),
            .selectionIndicatorHeight(2.0),
            .bottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .menuHeight(50.0),
            .menuItemWidth(90.0),
            .centerMenuItems(true),
            .useMenuLikeSegmentedControl(true),
            .scrollAnimationDurationOnMenuItemTap(220)
        ]
        
        // Initialize scroll menu
        let contentFrame = CGRect(x: 0, y: contentView.frame.origin.y, width: view.frame.width, height: view.frame.height)
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: contentFrame, pageMenuOptions: parameters)
        
        // Disabled changing view controller by left/right scrolling
        pageMenu?.controllerScrollView.isScrollEnabled = false
        
        addChildViewController(pageMenu!)
        view.addSubview(pageMenu!.view)
        
        pageMenu?.didMove(toParentViewController: self)
    }
    
    // MARK: - User interactions
    
    @IBAction func actionShowSettings(_ sender: UIBarButtonItem) {
        if let navigationController = UIStoryboard.stationSettingsNavigationController {
            if let stationSettingsTableViewController = navigationController.topViewController as? SettingsTableViewController {
                stationSettingsTableViewController.station = station
                present(navigationController, animated: true, completion: nil)
            }
        }
    }

}
