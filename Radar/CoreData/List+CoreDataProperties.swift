//
//  List+CoreDataProperties.swift
//  Radar
//
//  Created by test5 on 29/07/2022.
//
//

import Foundation
import CoreData


extension CoreDataList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataList> {
        return NSFetchRequest<CoreDataList>(entityName: "CoreDataList")
    }

    @NSManaged public var flightNumber: String?
    @NSManaged public var notes: String?
}

extension CoreDataList : Identifiable {

}
