//
//  SectionedDataSource.swift
//  KWDataSourceKit
//
//  Created by Mathias Nagler on 24.01.16.
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import UIKit

/// `SectionedDataSource` is a lightweight `DataSource` that can be used as a `UITableViewDataSource` or
/// `UICollectionViewDataSource`. `SectionedDataSource` supports multiple sections. To change the items
/// served by the `dataSource` set the `items` property.
/// - Note: If you need only one section, consider using `ArrayDataSource` instead
open class SectionedDataSource<CellType: Reusable, ItemType>: BaseDataSource<CellType, ItemType> {
    
    /// The sections served to a `UITableView` or `UICollectionView` by the `dataSource`
    /// - Note: Modifying this property causes the `dataSource` to call `reloadData()` on
    /// its `tableView` and `collectionView`
    public var sections = [Section<ItemType>]() {
        didSet {
            tableView?.reloadData()
            collectionView?.reloadData()
        }
    }
    
    /// Initializes a new `SectionedDataSource`
    /// - Parameter collectionView: A `collectionView` on which the `dataSource` should perform `insert`/`reload`/`delete` calls
    /// - Parameter tableView: A `tableView` on which the `dataSource` should perform `insert`/`reload`/`delete` calls
    /// - Parameter cellConfiguration: A `CellConfiguration` called for each cell to configure it with an item
    /// - Note: You should only ever provide a `tableView` *or* a `collectionView` for one `dataSource`
    public override init(collectionView: UICollectionView? = nil, tableView: UITableView? = nil, cellConfiguration: CellConfiguration? = nil) {
        super.init(collectionView: collectionView, tableView: tableView, cellConfiguration: cellConfiguration)
    }
    
    open override func numberOfSections() -> Int {
        return sections.count
    }
    
    open override func numberOfItems(inSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    open override func item(at indexPath: IndexPath) -> ItemType {
        return sections[indexPath.section].items[indexPath.row]
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }
    
}
