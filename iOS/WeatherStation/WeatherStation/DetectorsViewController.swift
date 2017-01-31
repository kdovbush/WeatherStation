//
//  DetectorsViewController.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 23/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit

class DetectorsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public properties
    
    var station: Station?
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    
        navigationItem.title = station?.name
        automaticallyAdjustsScrollViewInsets = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(detectorsDidChange(notification:)), name: NSNotification.Name(rawValue: "DetectorsDidChangeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settingsDidChange(notification:)), name: NSNotification.Name(rawValue: "SettingsDidChangeNotification"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Configuration methods
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "DetectorTableViewCell", bundle: nil), forCellReuseIdentifier: "DetectorTableViewCell")
    }
    
    // MARK: - User interactions
    
    @IBAction func actionShowSettings(_ sender: UIBarButtonItem) {
        if let navigationController = UIStoryboard.settingsNavigationController {
            if let stationSettingsTableViewController = navigationController.topViewController as? SettingsTableViewController {
                stationSettingsTableViewController.object = station
                present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Notification methods
    
    func settingsDidChange(notification: Notification) {
        tableView.reloadData()
    }
    
    func detectorsDidChange(notification: Notification) {
        tableView.reloadData()
    }
}


extension DetectorsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let detectors = station?.allDetectors {
            return detectors.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetectorTableViewCell", for: indexPath) as? DetectorTableViewCell {
            if let detectors = station?.allDetectors, indexPath.row < detectors.count {
                cell.detector = detectors[indexPath.row]
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension DetectorsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let detector = station?.allDetectors[indexPath.row] else { return }
        
        if let wrapperViewController = UIStoryboard.wrapperViewController {
            wrapperViewController.detector = detector
            navigationController?.pushViewController(wrapperViewController, animated: true)
        }
    }
    
}
