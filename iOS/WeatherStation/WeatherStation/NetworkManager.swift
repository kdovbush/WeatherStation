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

class NetworkManager: NSObject {

    static let shared = NetworkManager()
    
    func check(adress: String, completion: @escaping (Bool) -> Void) {
       
        // If station online - return true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            completion(false)
        }
    }
    
    func getMeasurements(for station: Station, completion: (_ measurements: [Measurements]?) -> Void) {
        
        // Return nil if some error occurred, else  - list of measurements
        completion(nil)
        
    }
    
    func getMeasurements(for station: Station, after timeStamp: TimeInterval, completion: (_ measurements: [Measurements]?) -> Void) {
        
        // Return nil if some error occurred, else  - list of measurements
        completion(nil)
        
    }
    
}
