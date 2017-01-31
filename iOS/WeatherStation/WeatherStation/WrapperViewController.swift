//
//  WrapperViewController.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/11/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit
import CoreData

class WrapperViewController: UIViewController {

    // MARK: - Public properties
    
    var detector: Detector?
    var pageMenu: CAPSPageMenu?
    
    // MARK: - Outlets
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    // MARK: - Viewcontroller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(settingsDidChange(_:)), name: NSNotification.Name(rawValue: "SettingsDidChangeNotification"), object: nil)
        
        navigationItem.title = detector?.name
        configurePageMenu()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notifications
    
    func settingsDidChange(_ notification: Notification) {
        if let object = notification.userInfo?["object"] as? NSManagedObject {
            switch object {
            case let detector as Detector:
                navigationItem.title = detector.name
            case let station as Station:
                navigationItem.title = station.name
            default:
                break
            }
        }
    }
   
    // MARK: - Helper methods
    
    func configurePageMenu() {
        
        // Initialize view controllers to display and place in array
        
        var controllerArray : [UIViewController] = []
        
        if let chartsViewController = UIStoryboard.chartsViewController {
            chartsViewController.title = "CHARTS"
            chartsViewController.detector = detector
            controllerArray.append(chartsViewController)
        }
        
        if let indicatorsViewController = UIStoryboard.indicatorsViewController {
            indicatorsViewController.title = "INDICATORS"
            indicatorsViewController.detector = detector
            controllerArray.append(indicatorsViewController)
        }
        
        if let historyViewController = UIStoryboard.historyViewController {
            historyViewController.title = "HISTORY"
            historyViewController.detector = detector
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
        
        pageMenu?.moveToPage(1, animated: false)
        
        addChildViewController(pageMenu!)
        view.addSubview(pageMenu!.view)
        
        pageMenu?.didMove(toParentViewController: self)
    }
    
    // MARK: - User interactions
    
    @IBAction func actionShowSettings(_ sender: UIBarButtonItem) {
        if let navigationController = UIStoryboard.settingsNavigationController {
            if let stationSettingsTableViewController = navigationController.topViewController as? SettingsTableViewController {
                stationSettingsTableViewController.object = detector
                present(navigationController, animated: true, completion: nil)
            }
        }
    }

}
