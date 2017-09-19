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
    case rowInsert(indexPath: IndexPath)
    case rowDelete(indexPath: IndexPath)
    case rowUpdate(indexPath: IndexPath)
    case rowMove(fromIndexPath: IndexPath, toIndexPath: IndexPath)
    case sectionInsert(sectionIndex: Int)
    case sectionDelete(sectionIndex: Int)
    case closure(closure: () -> ())
    
    func execute(on collectionView: UICollectionView) {
        switch self {
        case .rowInsert(let indexPath):
            collectionView.insertItems(at: [indexPath])
        case .rowDelete(let indexPath):
            collectionView.deleteItems(at: [indexPath])
        case .rowUpdate(let indexPath):
            collectionView.reloadItems(at: [indexPath])
        case .rowMove(let fromIndexPath, let toIndexPath):
            collectionView.moveItem(at: fromIndexPath, to: toIndexPath)
        case .sectionDelete(let sectionIndex):
            collectionView.deleteSections(IndexSet(integer: sectionIndex))
        case .sectionInsert(let sectionIndex):
            collectionView.insertSections(IndexSet(integer: sectionIndex))
        case .closure(let closure):
            closure()
        }
    }
}

open class CoreDataSource<CellType: Reusable, ItemType: NSFetchRequestResult>: BaseDataSource<CellType, ItemType>, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<ItemType>
    
    private var collectionViewChanges: [CollectionViewChanges]?
    
    @objc public var paused: Bool = false {
        didSet {
            if paused == oldValue { return }
            fetchedResultsController.delegate = !paused ? self : nil
            if !paused {
                loadContent()
            }
        }
    }
    
    public convenience init(fetchRequest: NSFetchRequest<ItemType>,
        inContext context: NSManagedObjectContext,
        sectionNameKeyPath: String? = nil,
        collectionView: UICollectionView? = nil,
        tableView: UITableView? = nil,
        cellConfiguration: CellConfiguration? = nil) {
            let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil);
            self.init(fetchedResultsController: controller, collectionView: collectionView, tableView: tableView, cellConfiguration: cellConfiguration)
    }
    
    public init(fetchedResultsController: NSFetchedResultsController<ItemType>,
        collectionView: UICollectionView? = nil,
        tableView: UITableView? = nil,
        cellConfiguration: CellConfiguration? = nil) {
            self.fetchedResultsController = fetchedResultsController
            super.init(collectionView: collectionView, tableView: tableView, cellConfiguration: cellConfiguration)
            self.fetchedResultsController.delegate = self
    }
    
    // MARK: - Fetching
    
    @objc public func loadContent() {
        do {
            try fetchedResultsController.performFetch()
            tableView?.reloadData()
            collectionView?.reloadData()
        } catch let error as NSError {
            print("An error occured while performing a fetch request: \(error.localizedDescription)")
        }
    }
    
    // MARK: - BaseDataSource
    
    open override func numberOfSections() -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    open override func numberOfItems(inSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    open override func item(at indexPath: IndexPath) -> ItemType {
        return fetchedResultsController.object(at: indexPath)
    }

    // MARK: - NSFetchedResultsControllerDelegate
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionViewChanges = collectionView != nil ? [CollectionViewChanges]() : nil
        self.tableView?.beginUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionViewChanges?.append(.rowInsert(indexPath: newIndexPath!))
            tableView?.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            collectionViewChanges?.append(.rowDelete(indexPath: indexPath!))
            tableView?.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            collectionViewChanges?.append(.rowUpdate(indexPath: indexPath!))
            tableView?.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            collectionViewChanges?.append(.rowMove(fromIndexPath: indexPath!, toIndexPath: newIndexPath!))
            tableView?.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            collectionViewChanges?.append(.sectionInsert(sectionIndex: sectionIndex))
            tableView?.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            collectionViewChanges?.append(.sectionDelete(sectionIndex: sectionIndex))
            tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            assertionFailure("Unsupported NSFetchedResultsChangeType!")
            break
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView?.endUpdates()
        
        if let collectionView = collectionView {
            collectionView.performBatchUpdates({
                self.collectionViewChanges?.forEach { $0.execute(on: collectionView) }
            },
            completion: { (finished) -> Void in
                self.collectionViewChanges?.removeAll()
            })
        }
    }
    
}
