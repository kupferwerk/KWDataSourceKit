//
//  SectionedDataSourceTests.swift
//  KWDataSourceKit
//
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import XCTest
@testable import KWDataSourceKit

class SectionedDataSourceTests: XCTestCase {

    var dataSource: SectionedDataSource<UITableViewCell, Model>!
    let tableView = UITableView()

    override func setUp() {
        super.setUp()

        let firstSection = Section<Model>(items: Model(title: "0"))
        firstSection.headerTitle = "First section header"
        firstSection.footerTitle = "First section footer"

        let secondSection = Section<Model>(items: Model(title: "1"), Model(title: "2"))
        secondSection.headerTitle = "Second section header"
        secondSection.footerTitle = "Second section footer"

        let sections = [
            firstSection,
            secondSection
        ]
        print(sections)

        dataSource = SectionedDataSource<UITableViewCell, Model>(collectionView: nil, tableView: nil) { (cell, item) in }
        dataSource.sections = sections
    }
    
    func testSectionCount() {
        XCTAssertEqual(dataSource.numberOfSections(), 2)
        XCTAssertEqual(dataSource.numberOfItems(inSection: 0), 1)
        XCTAssertEqual(dataSource.numberOfItems(inSection: 1), 2)
    }

    func testItems() {
        XCTAssertEqual(dataSource.item(at: IndexPath(row: 0, section: 0)).title, "0")
        XCTAssertEqual(dataSource.item(at: IndexPath(row: 0, section: 1)).title, "1")
        XCTAssertEqual(dataSource.item(at: IndexPath(row: 1, section: 1)).title, "2")
    }

    func testSeconHeaders() {
        XCTAssertEqual(dataSource.tableView(tableView, titleForHeaderInSection: 0), "First section header")
        XCTAssertEqual(dataSource.tableView(tableView, titleForHeaderInSection: 1), "Second section header")
    }

    func testSeconFooter() {
        XCTAssertEqual(dataSource.tableView(tableView, titleForFooterInSection: 0), "First section footer")
        XCTAssertEqual(dataSource.tableView(tableView, titleForFooterInSection: 1), "Second section footer")
    }
}
