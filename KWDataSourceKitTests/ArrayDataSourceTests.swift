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
        XCTAssertEqual(dataSource.numberOfItems(inSection: 0), 3)
    }

    func testInvalidSection() {
        expectingPreconditionFailure() {
            let _ = dataSource.numberOfItems(inSection: 1)
        }
    }

    func testItems() {
        let item0 = dataSource.item(at: IndexPath(item: 0, section: 0))
        XCTAssertEqual(item0.title, "0")

        let item1 = dataSource.item(at: IndexPath(item: 1, section: 0))
        XCTAssertEqual(item1.title, "1")

        let item2 = dataSource.item(at: IndexPath(item: 2, section: 0))
        XCTAssertEqual(item2.title, "2")
    }
}

