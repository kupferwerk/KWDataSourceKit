//
//  CoreDataSource.swift
//  KWDataSourceKit
//
//  Created by Mathias Nagler on 24.01.16.
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import UIKit
import CoreData

private enum CollectionViewChanges {
    case RowInsert(indexPath: NSIndexPath)
    case RowDelete(indexPath: NSIndexPath)
    case RowUpdate(indexPath: NSIndexPath)
    case RowMove(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath)
    case SectionInsert(sectionIndex: Int)
    case SectionDelete(sectionIndex: Int)
    case Closure(closure: () -> ())
    
    func executeOnCollectionView(collectionView: UICollectionView) {
        switch self {
        case .RowInsert(let indexPath):
            collectionView.insertItemsAtIndexPaths([indexPath])
        case .RowDelete(let indexPath):
            collectionView.deleteItemsAtIndexPaths([indexPath])
        case .RowUpdate(let indexPath):
            collectionView.reloadItemsAtIndexPaths([indexPath])
        case .RowMove(let fromIndexPath, let toIndexPath):
            collectionView.moveItemAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
        case .SectionDelete(let sectionIndex):
            collectionView.deleteSections(NSIndexSet(index: sectionIndex))
        case .SectionInsert(let sectionIndex):
            collectionView.insertSections(NSIndexSet(index: sectionIndex))
        case .Closure(let closure):
            closure()
        }
    }
}

public class CoreDataSource<CellType: Reusable, ItemType>: BaseDataSource<CellType, ItemType>, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController
    
    private var collectionViewChanges: [CollectionViewChanges]?
    
    public var paused: Bool = false {
        didSet {
            if paused == oldValue { return }
            fetchedResultsController.delegate = !paused ? self : nil
            if !paused {
                loadContent()
            }
        }
    }
    
    public convenience init(fetchRequest: NSFetchRequest,
        inContext context: NSManagedObjectContext,
        sectionNameKeyPath: String? = nil,
        collectionView: UICollectionView? = nil,
        tableView: UITableView? = nil,
        cellConfiguration: CellConfiguration? = nil) {
            let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil);
            self.init(fetchedResultsController: controller, collectionView: collectionView, tableView: tableView, cellConfiguration: cellConfiguration)
    }
    
    public init(fetchedResultsController: NSFetchedResultsController,
        collectionView: UICollectionView? = nil,
        tableView: UITableView? = nil,
        cellConfiguration: CellConfiguration? = nil) {
            self.fetchedResultsController = fetchedResultsController
            super.init(collectionView: collectionView, tableView: tableView, cellConfiguration: cellConfiguration)
            self.fetchedResultsController.delegate = self
    }
    
    // MARK: - Fetching
    
    public func loadContent() {
        do {
            try fetchedResultsController.performFetch()
            tableView?.reloadData()
            collectionView?.reloadData()
        } catch let error as NSError {
            print("An error occured while performing a fetch request: \(error.localizedDescription)")
        }
    }
    
    // MARK: - BaseDataSource
    
    public override func numberOfSections() -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    public override func numberOfItemsInSection(section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    public override func itemAtIndexPath(indexPath: NSIndexPath) -> ItemType {
        return fetchedResultsController.objectAtIndexPath(indexPath) as! ItemType
    }

    // MARK: - NSFetchedResultsControllerDelegate
    
    public func controller(controller: NSFetchedResultsController, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    public func controllerWillChangeContent(controller: NSFetchedResultsController) {
        collectionViewChanges = collectionView != nil ? [CollectionViewChanges]() : nil
        self.tableView?.beginUpdates()
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            collectionViewChanges?.append(.RowInsert(indexPath: newIndexPath!))
            tableView?.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            collectionViewChanges?.append(.RowDelete(indexPath: indexPath!))
            tableView?.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Update:
            collectionViewChanges?.append(.RowUpdate(indexPath: indexPath!))
            tableView?.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Move:
            collectionViewChanges?.append(.RowMove(fromIndexPath: indexPath!, toIndexPath: newIndexPath!))
            tableView?.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            collectionViewChanges?.append(.SectionInsert(sectionIndex: sectionIndex))
            tableView?.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            collectionViewChanges?.append(.SectionDelete(sectionIndex: sectionIndex))
            tableView?.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default:
            assertionFailure("Unsupported NSFetchedResultsChangeType!")
            break
        }
    }
    
    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView?.endUpdates()
        
        if let collectionView = collectionView {
            collectionView.performBatchUpdates({
                self.collectionViewChanges?.forEach { $0.executeOnCollectionView(collectionView) }
            },
            completion: { (finished) -> Void in
                self.collectionViewChanges?.removeAll()
            })
        }
    }
    
}
