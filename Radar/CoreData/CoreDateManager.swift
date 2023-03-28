//
//  CoreDateManager.swift
//  Radar
//
//  Created by Oran on 29/07/2022.
//

import UIKit

class CoreDateManager {
    
    static let shard = CoreDateManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchData() -> [CoreDataList]? {
        do{
            return try self.context.fetch(CoreDataList.fetchRequest())
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    func saveData(flightNumber: String, tasks: String, date: Date) {
        let CoreDataList = CoreDataList(context: context)
        CoreDataList.flightNumber = flightNumber
        CoreDataList.tasks = tasks
        CoreDataList.date = date
        do {
            try self.context.save()
        } catch {
            print("error: \(error)")
            
        }
    }
    
    func deleteData(index: Int) {
        if let dataArray = fetchData() {
            context.delete(dataArray[index])
            do {
                try self.context.save()
            } catch {
                print("error: \(error)")
            }
        }
    }
}
