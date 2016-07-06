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
        
        mainContext.performAndWait {
            do {
                try self.mainContext.save()
            } catch {
                print("Failed to save main context: \(error)")
            }
        }
    }
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let modelURL = Bundle.main.urlForResource("DataModel", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let _ = try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        return persistentStoreCoordinator
    }()

}

extension NSManagedObjectContext {
    
    func insert<T : NSManagedObject>(_ entity: T.Type) -> T {
        let entityName = entity.entityName
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into:self) as! T
    }
    
}

extension NSManagedObject {
    
    class var entityName: String {
        let components = NSStringFromClass(self).components(separatedBy: ".")
        return components[1]
    }

}
