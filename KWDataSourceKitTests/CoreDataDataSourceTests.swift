//
//  CoreDataDataSourceTests.swift
//  KWDataSourceKit
//
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import XCTest
import CoreData
@testable import KWDataSourceKit

class CoreDataDataSourceTests: XCTestCase {

    var dataSource: CoreDataSource<CustomTableViewCell, TestEntity>!

    override func setUp() {
        super.setUp()

        let mainContext = setUpInMemoryManagedObjectContext()

        let firstEntity = NSEntityDescription.insertNewObjectForEntityForName("TestEntity", inManagedObjectContext:mainContext) as! TestEntity
        firstEntity.title = "0"

        let secondEntity = NSEntityDescription.insertNewObjectForEntityForName("TestEntity", inManagedObjectContext:mainContext) as! TestEntity
        secondEntity.title = "1"

        let _ = try? mainContext.save()

        let fetchRequest = NSFetchRequest(entityName: "TestEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        dataSource = CoreDataSource<CustomTableViewCell, TestEntity>(fetchRequest: fetchRequest, inContext: mainContext, tableView: UITableView(), cellConfiguration: { (cell, item) -> () in
        })
        dataSource.loadContent()
    }
    
    func testSections() {
        XCTAssertEqual(dataSource.numberOfSections(), 1)
        XCTAssertEqual(dataSource.numberOfItemsInSection(0), 2)
    }

    func testItems() {
        let entity0 = dataSource.itemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
        XCTAssertEqual(entity0.title, "0")

        let entity1 = dataSource.itemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0))
        XCTAssertEqual(entity1.title, "1")
    }

    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let bundle = NSBundle(forClass: CoreDataDataSourceTests.self)
        let modelURL = bundle.URLForResource("Model", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)!

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        do {
            try persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store coordinator failed")
        }

        let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
}
