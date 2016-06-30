//
//  ArrayDataSourceTests.swift
//  KWDataSourceKit
//
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import XCTest
@testable import KWDataSourceKit

class ArrayDataSourceTests: XCTestCase {

    var dataSource: ArrayDataSource<CustomTableViewCell, Model>!

    override func setUp() {
        super.setUp()

        let items = [
            Model(title: "0"),
            Model(title: "1"),
            Model(title: "2")
        ]

        dataSource = ArrayDataSource<CustomTableViewCell, Model>(collectionView: nil, tableView: nil) { (cell, item) in }
        dataSource.items = items
    }

    func testSections() {
        XCTAssertEqual(dataSource.numberOfSections(), 1)
        XCTAssertEqual(dataSource.numberOfItemsInSection(0), 3)
    }

    func testInvalidSection() {
        expectingPreconditionFailure() {
            dataSource.numberOfItemsInSection(1)
        }
    }

    func testItems() {
        let item0 = dataSource.itemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
        XCTAssertEqual(item0.title, "0")

        let item1 = dataSource.itemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0))
        XCTAssertEqual(item1.title, "1")

        let item2 = dataSource.itemAtIndexPath(NSIndexPath(forItem: 2, inSection: 0))
        XCTAssertEqual(item2.title, "2")
    }
}

