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

        let firstEntity = NSEntityDescription.insertNewObject(forEntityName: "TestEntity", into:mainContext) as! TestEntity
        firstEntity.title = "0"

        let secondEntity = NSEntityDescription.insertNewObject(forEntityName: "TestEntity", into:mainContext) as! TestEntity
        secondEntity.title = "1"

        let _ = try? mainContext.save()

        let fetchRequest = NSFetchRequest<TestEntity>(entityName: "TestEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        dataSource = CoreDataSource<CustomTableViewCell, TestEntity>(fetchRequest: fetchRequest, inContext: mainContext, tableView: UITableView(), cellConfiguration: { (cell, item) -> () in
        })
        dataSource.loadContent()
    }
    
    func testSections() {
        XCTAssertEqual(dataSource.numberOfSections(), 1)
        XCTAssertEqual(dataSource.numberOfItems(inSection: 0), 2)
    }

    func testItems() {
        let entity0 = dataSource.item(at: IndexPath(item: 0, section: 0))
        XCTAssertEqual(entity0.title, "0")

        let entity1 = dataSource.item(at: IndexPath(item: 1, section: 0))
        XCTAssertEqual(entity1.title, "1")
    }

    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let bundle = Bundle(for: CoreDataDataSourceTests.self)
        let modelURL = bundle.url(forResource: "Model", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store coordinator failed")
        }

        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
}
