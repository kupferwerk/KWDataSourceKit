//
//  ReusableTests.swift
//  KWDataSourceKit
//
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import XCTest
@testable import KWDataSourceKit

class ReusableTests: XCTestCase {

    func testDefaultCellIdentifier() {
        XCTAssertEqual(UITableViewCell.reuseId, "UITableViewCell")
        XCTAssertEqual(UICollectionViewCell.reuseId, "UICollectionViewCell")
    }

    func testCustomCellsIdentifier() {
        XCTAssertEqual(CustomTableViewCell.reuseId, "CustomTableViewCell")
        XCTAssertEqual(CustomCollectionViewCell.reuseId, "CustomCollectionViewCell")
    }
}
