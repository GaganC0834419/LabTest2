//
//  CoreDatabase.swift
//  TicTacToe
//
//

import Foundation
import UIKit
import CoreData


class CoreDatabase {
    
    func loadSaveData(completionBlock : @escaping ((_ isXturn : Bool,_ xScore : Int,_ oScore: Int,_ resumeData:[[String: Any]]) -> Void))  {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: AppConstants.coreDataEntityName)
        
        do {
            let results = try context.fetch(fetchRequest)
            let obtainedResults = results as! [NSManagedObject]
            if obtainedResults.count > 0{
                let firstResult = obtainedResults.last
                let isXturn = firstResult?.value(forKey: AppConstants.xTurn_Key) as? Bool ?? false
                let oscore = firstResult?.value(forKey: AppConstants.oScore_Key) as? Int ?? 0
                let xscore = firstResult?.value(forKey: AppConstants.xScore_Key) as? Int ?? 0
                let data = firstResult?.value(forKey: AppConstants.boardData_Key) as? [[String: Any]] ?? [[:]]
                completionBlock(isXturn,xscore,oscore,data)
            }
        } catch {
            print("Error")
        }
    }
    
    
    
    
    func saveDataInCoreData(isXturn : Bool,oScore:Int,xScore: Int,boardData : [[String: Any]]) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: AppConstants.coreDataEntityName,
                                       in: managedContext)!
        
        let item = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        item.setValue(isXturn, forKey: AppConstants.xTurn_Key)
        item.setValue(oScore, forKey: AppConstants.oScore_Key)
        item.setValue(xScore, forKey: AppConstants.xScore_Key)
        item.setValue(boardData, forKey: AppConstants.boardData_Key)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
