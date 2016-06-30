//
//  TestClasses.swift
//  KWDataSourceKit
//
//  Created by Michael Kao on 30/03/16.
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import XCTest
import CoreData

class CustomTableViewCell: UITableViewCell {
}

class CustomCollectionViewCell: UICollectionViewCell {
}

internal struct Model {
    let title: String
}

class TestEntity: NSManagedObject {
    @NSManaged var title: String
}
