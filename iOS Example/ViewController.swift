//
//  ViewController.swift
//  KWDataSouce iOS Example
//
//  Created by Mathias Nagler on 24.01.16.
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import UIKit
import KWDataSourceKit

class ViewController: UITableViewController {
    
    private struct Link {
        private let title: String
        private let segueIdentifier: String
    }
    
    private let items  = [
        Link(title: "Table - SectionedDataSource", segueIdentifier: "sectioned-table"),
        Link(title: "Table - CoreDataSource", segueIdentifier: "coredata-table"),
        Link(title: "Collection - CoreDataSource", segueIdentifier: "coredata-collection")]
    
    private var dataSource: ArrayDataSource<TableViewCell, Link>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = ArrayDataSource<TableViewCell, Link>(tableView: tableView, cellConfiguration: { (cell, item) -> () in
            cell.textLabel?.text = item.title
        })
        
        dataSource.items = items
        tableView.dataSource = dataSource
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = dataSource.item(at: indexPath)
        performSegue(withIdentifier: link.segueIdentifier, sender: self)
    }


}

