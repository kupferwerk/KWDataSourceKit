//
//  ArrayDataSource.swift
//  KWDataSourceKit
//
//  Created by Mathias Nagler on 24.01.16.
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import UIKit

/// `ArrayDataSource` is a lightweight `DataSource` that can be used as a `UITableViewDataSource` or
/// `UICollectionViewDataSource`. `ArrayDataSource` always uses a single section. To change the items
/// served by the `dataSource` set the `items` property.
/// - Note: If you need multiple sections, use `SectionedDataSource` instead
open class ArrayDataSource<CellType: Reusable, ItemType>: BaseDataSource<CellType, ItemType> {
    
    /// The items served to a `UITableView` or `UICollectionView` by the `dataSource`
    /// - Note: Modifying this property causes the `dataSource` to call `reloadData()` on
    /// its `tableView` and `collectionView`
    public var items = [ItemType]() {
        didSet {
            tableView?.reloadData()
            collectionView?.reloadData()
        }
    }
    
    /// Initializes a new `ArrayDataSource`
    /// - Parameter collectionView: A `collectionView` on which the `dataSource` should perform `insert`/`reload`/`delete` calls
    /// - Parameter tableView: A `tableView` on which the `dataSource` should perform `insert`/`reload`/`delete` calls
    /// - Parameter cellConfiguration: A `CellConfiguration` called for each cell to configure it with an item
    /// - Note: You should only ever provide a `tableView` *or* a `collectionView` for one `dataSource`
    public override init(collectionView: UICollectionView? = nil, tableView: UITableView? = nil, cellConfiguration: CellConfiguration? = nil) {
        super.init(collectionView: collectionView, tableView: tableView, cellConfiguration: cellConfiguration)
    }
    
    open override func numberOfSections() -> Int {
        return items.count > 0 ? 1 : 0
    }
    
    open override func numberOfItems(inSection section: Int) -> Int {
        precondition(section == 0, "There should only be one section")
        return items.count
    }
    
    open override func item(at indexPath: IndexPath) -> ItemType {
        return items[indexPath.row]
    }
    
}
