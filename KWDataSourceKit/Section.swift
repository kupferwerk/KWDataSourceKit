//
//  Section.swift
//  KWDataSourceKit
//
//  Created by Mathias Nagler on 24.01.16.
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import Foundation

public class Section<ItemType> {
    
    public private(set) var items = [ItemType]()
    
    public var headerTitle: String?
    public var footerTitle: String?
    
    public convenience init(items: ItemType...) {
        self.init(items: items)
    }
    
    public init(items: [ItemType]) {
        self.items = items
    }
    
    public func add(_ item: ItemType) {
        items.append(item)
    }
    
    public func add(_ newItems: ItemType...) {
        items.append(contentsOf: newItems)
    }
    
    public func add(contentsOf newItems: [ItemType]) {
        items.append(contentsOf: newItems)
    }
    
}
