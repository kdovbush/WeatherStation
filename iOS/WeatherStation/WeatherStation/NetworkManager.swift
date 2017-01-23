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
    
    func getMeasurements(for station: Station, completion: @escaping (_ measurements: [Measurements]?) -> Void) {
        guard let address = station.address else {
            completion(nil)
            return
        }
        
        if let url = URL(string: APIConnections.getMeasurements(address).url), let sessionManager = sessionManager {
            sessionManager.request(url).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success:
                    if let data = response.data {
                        // TODO: Change
                        //let measurements = Measurements.parseMeasurements(data: data, for: station)
                        //completion(measurements)
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
    
    func getMeasurements(for station: Station, after timeStamp: TimeInterval, completion: @escaping (_ measurements: [Measurements]?) -> Void) {
        guard let address = station.address else {
            completion(nil)
            return
        }
        
        if let url = URL(string: APIConnections.getMeasurementsAfter(address, timeStamp).url), let sessionManager = sessionManager {
            sessionManager.request(url).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success:
                    if let data = response.data {
                        // TODO: Change
                        //let measurements = Measurements.parseMeasurements(data: data, for: station)
                        //completion(measurements)
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
    
    func clean(for station: Station, completion: @escaping (Bool) -> Void) {
        guard let address = station.address else {
            completion(false)
            return
        }
        
        if let url = URL(string: APIConnections.clean(address).url), let sessionManager = sessionManager {
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
    case getMeasurements(String)
    case getMeasurementsAfter(String, Double)
    case clean(String)
    
    var url: String {
        switch self {
        case .check(let address):
            return Constants.http + address + Constants.check
        case .getMeasurements(let address):
            return Constants.http + address + Constants.getMeasurements
        case .getMeasurementsAfter(let address, let after):
            return Constants.http + address + Constants.getMeasurementsAfter + "/\(after)"
        case .clean(let address):
            return Constants.http + address + Constants.clean
        }
    }
}

struct Constants {
    static let http = "http://"
    static let path = ":5000/api/v1.0"
    
    static let check = path + "/check"
    static let getMeasurements = path + "/measurements"
    static let getMeasurementsAfter = path + "/measurementsAfter"
    static let clean = path + "/clean"
}
