//
//  asFile.swift
//  KWDataSourceKit
//
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import XCTest
@testable import KWDataSourceKit

class BaseDataSourceTests: XCTestCase {

    var tableView: UITableView!
    var collectionView: UICollectionView!

    override func setUp() {
        super.setUp()

        tableView = UITableView()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    func testFailingInitializaiton() {
        expectingPreconditionFailure() {
            let _ = BaseDataSource<UITableViewCell, NSObject>(collectionView: collectionView, tableView: tableView) { (cell, item) in }
        }
    }

    func testFailingTableViewSetting() {
        let dataSource = BaseDataSource<UITableViewCell, NSObject>(collectionView: nil, tableView: nil) { (cell, item) in }
        dataSource.tableView = tableView

        expectingPreconditionFailure() {
            dataSource.collectionView = collectionView
        }
    }

    func testFailingCollectionViewSetting() {
        let dataSource = BaseDataSource<UITableViewCell, NSObject>(collectionView: nil, tableView: nil) { (cell, item) in }
        dataSource.collectionView = collectionView

        expectingPreconditionFailure() {
            dataSource.tableView = tableView
        }
    }
}
