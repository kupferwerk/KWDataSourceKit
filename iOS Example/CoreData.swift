//
//  CoreData.swift
//  KWDataSourceKit
//
//  Created by Mathias Nagler on 26.01.16.
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import CoreData

/// NOTE: The core data stack used in this project should not serve as an example on how to use core data.
/// It is merly a barebone stack to show of how `CoreDataSource` works

class CoreData {
    
    static let sharedController = CoreData()
    private init() { }
    
    func save() {
        if !mainContext.hasChanges {
            return
        }
        
        mainContext.performBlockAndWait {
            do {
                try self.mainContext.save()
            } catch {
                print("Failed to save main context: \(error)")
            }
        }
    }
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let _ = try! persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        return persistentStoreCoordinator
    }()

}

extension NSManagedObjectContext {
    
    func insert<T : NSManagedObject>(entity: T.Type) -> T {
        let entityName = entity.entityName
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext:self) as! T
    }
    
}

extension NSManagedObject {
    
    class var entityName: String {
        let components = NSStringFromClass(self).componentsSeparatedByString(".")
        return components[1]
    }
    
    class var request: NSFetchRequest {
        return NSFetchRequest(entityName: entityName)
    }
}