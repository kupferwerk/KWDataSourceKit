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
    
    @objc open var paused: Bool = true {
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
    
    // MARK: - Configuration
    
    @objc public func set(fetchRequest: NSFetchRequest<ItemType>, sectionNameKeyPath: String? = nil) {
        let context = fetchedResultsController.managedObjectContext
        fetchedResultsController.delegate = nil
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
        
        if !paused {
            fetchedResultsController.delegate = self
            loadContent()
        }
    }
    
    // MARK: - Fetching
    
    @objc private func loadContent() {
        do {
            try fetchedResultsController.performFetch()
            tableView?.reloadData()
            collectionView?.reloadData()
            didLoadContent()
        } catch let error as NSError {
            print("An error occured while performing a fetch request: \(error.localizedDescription)")
        }
    }
    
    @objc open func didLoadContent() {
        // Overwrite in subclasses
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
    
    // MARK: - Public
    
    open func title(forHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    open func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionViewChanges = collectionView != nil ? [CollectionViewChanges]() : nil
        self.tableView?.beginUpdates()
    }
    
    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionViewChanges?.append(.rowInsert(indexPath: newIndexPath!))
            tableView?.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            collectionViewChanges?.append(.rowDelete(indexPath: indexPath!))
            tableView?.deleteRows(at: [indexPath!], with: .fade)
        case .update, .move:
            if indexPath == newIndexPath {
                collectionViewChanges?.append(.rowUpdate(indexPath: indexPath!))
                tableView?.reloadRows(at: [indexPath!], with: .none)
            } else {
                collectionViewChanges?.append(.rowMove(fromIndexPath: indexPath!, toIndexPath: newIndexPath!))
                tableView?.deleteRows(at: [indexPath!], with: .fade)
                tableView?.insertRows(at: [newIndexPath!], with: .fade)
            }
        }
    }
    
    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            collectionViewChanges?.append(.sectionInsert(sectionIndex: sectionIndex))
            tableView?.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            collectionViewChanges?.append(.sectionDelete(sectionIndex: sectionIndex))
            tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            assertionFailure("Unsupported NSFetchedResultsChangeType!")
            break
        }
    }
    
    open func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let tableView = tableView {
            tableView.endUpdates()
            didChangeContent()
        }
        
        if let collectionView = collectionView {
            collectionView.performBatchUpdates({
                self.collectionViewChanges?.forEach { $0.execute(on: collectionView) }
            }, completion: { (finished) -> Void in
                self.collectionViewChanges?.removeAll()
                self.didChangeContent()
            })
        }
    }
    
    @objc open func didChangeContent() {
        // Override in subclasses
    }
}
