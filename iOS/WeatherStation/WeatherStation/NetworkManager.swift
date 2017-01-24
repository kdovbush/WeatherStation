//
//  NetworkManager.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/17/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import MagicalRecord
import SwiftyJSON

class NetworkManager: NSObject {

    // MARK: - Properties
    
    static let shared = NetworkManager()

    let configuration = URLSessionConfiguration.default
    var sessionManager: SessionManager?
    
    // MARK: - Private constructor
    
    private override init() {
        super.init()
        
        configuration.timeoutIntervalForRequest = 2
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    // MARK: - Public methods
    
    // Checks if passed station address is online
    func check(address: String, completion: @escaping (Bool) -> Void) {
        if let url = URL(string: APIConnections.check(address).url), let sessionManager = sessionManager {
            sessionManager.request(url).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success:
                    if let data = response.data {
                        let json = JSON(data: data)
                        let status = json["status"].boolValue
                        completion(status)
                    } else {
                        completion(false)
                    }
                case .failure:
                    completion(false)
                }
            })
        } else {
            completion(false)
        }
    }
    
    // Returns list of detectors for station
    func getDetectors(for station: Station, completion: @escaping (_ detectors: [Detector]?) -> Void) {
        guard let address = station.address else {
            completion(nil)
            return
        }
        
        if let url = URL(string: APIConnections.getDetectors(address).url), let sessionManager = sessionManager {
            sessionManager.request(url).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success:
                    if let data = response.data {
                        let detectors = Detector.parseDetectors(data: data, for: station)
                        completion(detectors)
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
            })
        } else {
            completion(nil)
        }
    }
    
    // Returns list of measurements for station address and detector id
    func getMeasurements(for station: Station, detector: Detector, completion: @escaping (_ measurements: [Measurements]?) -> Void) {
        guard let address = station.address else {
            completion(nil)
            return
        }
        
        if let url = URL(string: APIConnections.getMeasurementsFor(address, Int(detector.id)).url), let sessionManager = sessionManager {
            sessionManager.request(url).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success:
                    if let data = response.data {
                        let measurements = Measurements.parseMeasurements(data: data, for: detector)
                        completion(measurements)
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
            })
        } else {
            completion(nil)
        }
    }
    
    // Returns list of measurements for station address and detector id after specified time
    func getMeasurements(for station: Station, detector: Detector, after timeStamp: TimeInterval, completion: @escaping (_ measurements: [Measurements]?) -> Void) {
        guard let address = station.address else {
            completion(nil)
            return
        }
        print("\(address)  \(detector.detectorId)  \(timeStamp)")
        print(APIConnections.getMeasurementsAfter(address, Int(detector.detectorId), timeStamp).url)
        
        if let url = URL(string: APIConnections.getMeasurementsAfter(address, Int(detector.detectorId), timeStamp).url), let sessionManager = sessionManager {
            sessionManager.request(url).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success:
                    if let data = response.data {
                        let measurements = Measurements.parseMeasurements(data: data, for: detector)
                        completion(measurements)
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
            })
        } else {
            completion(nil)
        }
    }
    
    // Cleans all measurements for station
    func cleanMeasurements(for station: Station, completion: @escaping (Bool) -> Void) {
        guard let address = station.address else {
            completion(false)
            return
        }
        
        if let url = URL(string: APIConnections.cleanMeasurements(address).url), let sessionManager = sessionManager {
            sessionManager.request(url).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success:
                    if let data = response.data {
                        let json = JSON(data: data)
                        let status = json["status"].boolValue
                        completion(status)
                    } else {
                        completion(false)
                    }
                case .failure:
                    completion(false)
                }
            })
        } else {
            completion(false)
        }
    }
    
    // Cleans measurements of detector in station
    func cleanMeasurements(for station: Station, detector: Detector, completion: @escaping (Bool) -> Void) {
        guard let address = station.address else {
            completion(false)
            return
        }
        
        if let url = URL(string: APIConnections.cleanMeasurementsOf(address, Int(detector.detectorId)).url), let sessionManager = sessionManager {
            sessionManager.request(url).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success:
                    if let data = response.data {
                        let json = JSON(data: data)
                        let status = json["status"].boolValue
                        completion(status)
                    } else {
                        completion(false)
                    }
                case .failure:
                    completion(false)
                }
            })
        } else {
            completion(false)
        }
    }
    
}

enum APIConnections {
    case check(String)
    case getDetectors(String)
    case getMeasurementsFor(String, Int)
    case getMeasurementsAfter(String, Int, Double)
    case cleanMeasurements(String)
    case cleanMeasurementsOf(String, Int)
    
    var url: String {
        switch self {
        case .check(let address):
            return Constants.http + address + Constants.check
        case .getDetectors(let address):
            return Constants.http + address + Constants.detectors
        case .getMeasurementsFor(let address, let detectorId):
            return Constants.http + address + Constants.detectors + "/\(detectorId)" + Constants.measurements
        case .getMeasurementsAfter(let address, let detectorId, let after):
            return Constants.http + address + Constants.detectors + "/\(detectorId)" + Constants.measurementsAfter + "/\(after)"
        case .cleanMeasurements(let address):
            return Constants.http + address + Constants.cleanMeasurements
        case .cleanMeasurementsOf(let address, let detectorId):
            return Constants.http + address + Constants.cleanMeasurementsOf + "/\(detectorId)"
        }
    }
}

struct Constants {
    static let http = "http://"
    static let path = ":5000/api/v1.0"
    
    static let check = path + "/checkStatus"
    static let detectors = path + "/detectors"
    static let measurements = "/measurements"
    static let measurementsAfter = "/measurementsAfter"
    static let cleanMeasurements = path + "/cleanMeasurements"
    static let cleanMeasurementsOf = path + "/cleanMeasurementsOfDetector"
}
