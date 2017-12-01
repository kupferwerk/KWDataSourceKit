//
//  Section.swift
//  KWDataSourceKit
//
//  Created by Mathias Nagler on 24.01.16.
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import Foundation

/// `Section` is a value type that contains section information for a single element of a `SectionedDataSource`'s
/// `sections` array property.
/// - Note: Create an area of these objects and set them to the `sections` property on `SectionedDataSource`
public class Section<ItemType> {
    
    /// items is an array of generic objects that are served to a `UITableView` or `UICollectionView`
    /// by the `dataSource` and is set in one of the initializers. It contains the cells data and is accessed
    /// in the `CellConfiguration` closure when setting up the `dataSource`.
    public private(set) var items = [ItemType]()
    
    /// headerTitle is an optional text string to be displayed in the section header
    public var headerTitle: String?
    
    /// footerTitle is an optional text string to be displazed in the section footer
    public var footerTitle: String?

    /// Initializes a new `Section`
    /// - Parameter items: comma delimited items to be fed by the `dataSource`.
    public convenience init(items: ItemType...) {
        self.init(items: items)
    }
    
    /// Initializes a new `Section`
    /// - Parameter items: array of items to be fed by the `dataSource`.
    public init(items: [ItemType]) {
        self.items = items
    }
    
    /// helper method used to add an additional item to the `Section`.
    /// - Paramater item: single generic item
    public func add(_ item: ItemType) {
        items.append(item)
    }
    
    /// helper method used to add multiple items to the `Section`.
    /// - Paramater _ newItems: comma delimited items
    public func add(_ newItems: ItemType...) {
        items.append(contentsOf: newItems)
    }
    
    /// helper method used to add multiple items to the `Section`.
    /// - Paramater contentsOf: array of items
    public func add(contentsOf newItems: [ItemType]) {
        items.append(contentsOf: newItems)
    }
    
}
