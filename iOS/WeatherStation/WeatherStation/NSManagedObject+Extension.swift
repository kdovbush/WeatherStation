//
//  NSManagedObject+Extension.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 12/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord

extension NSManagedObject {
    
    @nonobjc static let context = NSManagedObjectContext.mr_default()
    
    func save() {
        NSManagedObject.context.mr_saveToPersistentStoreAndWait()
    }
    
    func remove() {
        mr_deleteEntity(in: NSManagedObject.context)
        save()
    }
    
}
