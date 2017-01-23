//
//  StationsViewController.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 02/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit
import MagicalRecord

enum Section: Int {
    case online
    case offline
}

class StationsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public properties
    
    var allStation: [Station] = []
    
    // MARK: - Private properties
    
    fileprivate var onlineStations: [Station] = []
    fileprivate var offlineStations: [Station] = []
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(stationDidChange(_:)), name: NSNotification.Name(rawValue: "StationDidChangeNotification"), object: nil)
        
        reloadStations()
        configureTableView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notifications
    
    func stationDidChange(_ notification: Notification) {
        reloadStations()
        tableView.reloadData()
    }

    // MARK: - Configuration methods
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "StationTableViewCell", bundle: nil), forCellReuseIdentifier: "StationTableViewCell")
    }
    
    func reloadStations() {
        allStation = Station.getAll()
        
        // Separate all stations to online/offline sections
        onlineStations = []
        offlineStations = []
        
        for station in allStation {
            if station.available {
                onlineStations.append(station)
            } else {
                offlineStations.append(station)
            }
        }
    }
    
    // MARK: - User interactions

    @IBAction func actionAddNewStation(_ sender: UIBarButtonItem) {
        if let navigationController = UIStoryboard.newStationNavigationController {
            if let newStationViewContoller = navigationController.topViewController as? NewStationViewController {
                newStationViewContoller.delegate = self
                present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func actionRefreshStations(_ sender: UIBarButtonItem) {
        reloadStations()
        tableView.reloadData()
    }
}

extension StationsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.online.rawValue:
            return onlineStations.count
        case Section.offline.rawValue:
            return offlineStations.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StationTableViewCell", for: indexPath) as? StationTableViewCell {
            
            switch indexPath.section {
            case Section.online.rawValue:
                let station = onlineStations[indexPath.row]
                cell.station = station
            case Section.offline.rawValue:
                let station = offlineStations[indexPath.row]
                cell.station = station
            default:
                break
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.online.rawValue:
            return "Online"
        case Section.offline.rawValue:
            return "Offline"
        default:
            return nil
        }
    }
    
}

extension StationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var station: Station? = nil
        
        switch indexPath.section {
        case Section.online.rawValue:
            station = onlineStations[indexPath.row]
        case Section.offline.rawValue:
            station = offlineStations[indexPath.row]
        default:
            return
        }
        
        if let detectorsViewController = UIStoryboard.detectorsViewController, let station = station {
            detectorsViewController.station = station
            navigationController?.pushViewController(detectorsViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertView = UIAlertController(title: "Delete station", message: "Are you sure you want to permanently delete this station?", preferredStyle: .actionSheet)
            alertView.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                
                switch indexPath.section {
                case Section.online.rawValue:
                    let station = self.onlineStations[indexPath.row]
                    station.remove()
                    self.onlineStations.remove(at: indexPath.row)
                case Section.offline.rawValue:
                    let station = self.offlineStations[indexPath.row]
                    station.remove()
                    self.offlineStations.remove(at: indexPath.row)
                default:
                    return
                }
                
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }))
            alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                tableView.setEditing(false, animated: true)
            }))
            
            present(alertView, animated: true, completion: nil)
        }
    }
    
}

extension StationsViewController: NewStationDelegate {
    
    func stationAdded(station: Station) {
        reloadStations()
        tableView.reloadData()
    }
    
}










