//
//  BaseDataSource.swift
//  KWDataSourceKit
//
//  Created by Mathias Nagler on 24.01.16.
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import UIKit

/// `BaseDataSource` is an abstract `DataSource` that contains functionality used by several other `DataSources`. It can not
/// be used directly, as some methods need to implemented by subclasses: 
/// - `item(at indexPath: NSIndexPath) -> ItemType`
/// - `indexPath(for: item: ItemType) -> NSIndexPath?`
/// - `numberOfSections() -> Int`
/// - `numberOfItems(inSection section: Int) -> Int`
/// If you are implementing your own subclass of `BaseDataSource` be sure to implement these methods. The default implementation
/// causes a `fatalError` to warn about incomplete subclasses.
open class BaseDataSource<CellType: Reusable, ItemType>: NSObject, UITableViewDataSource, UICollectionViewDataSource {
    
    /// A closure used for configuring a `cell` with an item so it can be displayed in a `tableView` or `collectionView`
    /// - Parameter cell: The `tableViewCell` or collection view cell that should be configured
    /// - Parameter item: The model item which should be displayed in a cell
    public typealias CellConfiguration = (_ cell: CellType, _ item: ItemType) -> ()
    
    /// The closure called for each cell, configuring cells with items to be displayed.
    /// - See: `CellConfiguration`
    public private(set) var cellConfiguration: CellConfiguration?
    
    /// If the `collectionView` property is assigned, the `dataSource` will perform `insert`/`reload`/`delete` calls on it as the
    /// `dataSource`'s data changes
    @objc public weak var collectionView: UICollectionView? {
        willSet {
            precondition(!(newValue != nil && tableView != nil), "TableView property is already assigned. Use either a collectionView *OR* a tableView. Using both at the same time is not supported!")
        }
    }
    
    /// If the `tableView` property is assigned, the `dataSource` will perform `insert`/`reload`/`delete` calls on it as the
    /// `dataSource`'s data changes
    @objc public weak var tableView: UITableView? {
        willSet {
            precondition(!(newValue != nil && collectionView != nil), "CollectionView property is already assigned. Use either a collectionView *OR* a tableView. Using both at the same time is not supported!")
        }
    }
    
    /// Initializes a new `BaseDataSource`
    /// - Parameter collectionView: A `collectionView` on which the `dataSource` should perform `insert`/`reload`/`delete` calls
    /// - Parameter tableView: A `tableView` on which the `dataSource` should perform `insert`/`reload`/`delete` calls
    /// - Parameter cellConfiguration: A `CellConfiguration` called for each cell to configure it with an item
    /// - Note: You should only ever provide a `tableView` *or* a `collectionView` for one `dataSource`
    public init(collectionView: UICollectionView? = nil, tableView: UITableView? = nil, cellConfiguration: CellConfiguration? = nil) {
        
        precondition(!(collectionView != nil && tableView != nil), "Use either a collectionView *OR* a tableView. Using both at the same time is not supported!")
        
        self.cellConfiguration = cellConfiguration
        self.collectionView = collectionView
        self.tableView = tableView
    }
    
    /// Returns the item for a given `indexPath`
    /// - Parameter at: An `indexPath` locating the item in the `dataSource`
    /// - Returns: The item located at the given `indexPath`
    open func item(at indexPath: IndexPath) -> ItemType {
        fatalError("\(#function) has to be implemented by subclasses!")
    }
    
    /// Returns the `indexPath` for a given item
    /// - Parameter for: The item for which the locating `indexPath` should be returned
    /// - Returns: An `indexPath` locating the item in the `dataSource` or nil if the given item was not found in the `dataSource`
    open func indexPath(for item: ItemType) -> IndexPath? {
        fatalError("\(#function) has to be implemented by subclasses!")
    }
    
    /// Returns the number of sections in the `dataSource`
    /// - Returns: The number of sections
    @objc open func numberOfSections() -> Int {
        fatalError("\(#function) has to be implemented by subclasses!")
    }
    
    /// Returns the number of items in a given section in the `dataSource`
    /// - Parameter inSection: The section of which the number of items should be returned
    /// - Returns: The number of items in the given section
    @objc open func numberOfItems(inSection section: Int) -> Int {
        fatalError("\(#function) has to be implemented by subclasses!")
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.reuseId, for: indexPath)
        
        if let cellConfiguration = cellConfiguration {
            cellConfiguration(cell as! CellType, item(at: indexPath))
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.reuseId, for: indexPath)
        
        if let cellConfiguration = cellConfiguration {
            cellConfiguration(cell as! CellType, item(at: indexPath))
        }
        
        return cell
    }
    
}
