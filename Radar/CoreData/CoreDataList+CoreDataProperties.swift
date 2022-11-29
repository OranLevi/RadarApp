//
//  CoreDataList+CoreDataProperties.swift
//  Radar
//
//  Created by Oran on 29/07/2022.
//
//

import Foundation
import CoreData

extension CoreDataList {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataList> {
        return NSFetchRequest<CoreDataList>(entityName: "CoreDataList")
    }
    
    @NSManaged public var flightNumber: String?
    @NSManaged public var tasks: String?
    @NSManaged public var date: Date?
    
}

extension CoreDataList : Identifiable {
    
}
