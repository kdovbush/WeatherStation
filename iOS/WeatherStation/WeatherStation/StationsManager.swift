//
//  StationsManager.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/21/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import Foundation
import UIKit

class StationsManager: NSObject {
    
    // MARK: - Properties
    
    static let shared = StationsManager()
    
    // MARK: - Private properties
    
    fileprivate var timer: Timer?
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Public methods
    
    func start() {
        timer?.invalidate()
        timer =  Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(checkStations), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func checkStations() {
        let stations = Station.getAll()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        for station in stations {
            if let stationAddress = station.address {
                NetworkManager.shared.check(address: stationAddress, completion: { (available) in
                    self.hideNetworkActivityStatusWithDelay()
                    
                    if available {
                        station.available = true
                        self.updateDetectors(for: station)
                    } else {
                        station.available = false
                    }
                    
                    print("\(stationAddress) - \(available)")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StationDidChangeNotification"), object: nil, userInfo: ["station":station])
                })
            }
        }
    }
    
    func updateDetectors(for station: Station) {
        NetworkManager.shared.getDetectors(for: station) { (detectors) in
            if let detectors = detectors {
                for detector in detectors {
                    self.updateMeasurements(for: detector, of: station)
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DetectorsDidChangeNotification"), object: nil, userInfo: ["detectors": detectors])
            }
        }
    }
    
    func updateMeasurements(for detector: Detector, of station: Station) {
        let lastTimestamp = detector.allMeasurements.last?.createdAt.timeIntervalSince1970 ?? 0.0
        
        NetworkManager.shared.getMeasurements(for: station, detector: detector, after: lastTimestamp) { (measurements) in
            if let measurements = measurements {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DetectorDidChangeNotification"), object: nil, userInfo: ["detector":detector])
            }
        }
    }
    
    fileprivate func hideNetworkActivityStatusWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
}
