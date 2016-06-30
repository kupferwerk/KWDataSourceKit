//
//  SectionedTableViewController.swift
//  KWDataSourceKit
//
//  Created by Mathias Nagler on 26.01.16.
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import UIKit
import KWDataSourceKit

class SectionedTableViewController: UITableViewController {
    
    private let items: [Section<String>] = {
        let firstSection = Section<String>(items: "Lorem", "ipsum")
        firstSection.headerTitle = "First section header"
        firstSection.footerTitle = "First section footer"
        
        let secondSection = Section<String>(items: ["dolor", "sit", "amet"])
        secondSection.headerTitle = "Second section header"
        secondSection.footerTitle = "Second section footer"

        let thirdSection = Section<String>(items: "consetetur", "sadipscing")
        thirdSection.headerTitle = "Third section header"
        thirdSection.footerTitle = "Third section footer"
        
        return [firstSection, secondSection, thirdSection]
    }()
    
    private var dataSource: SectionedDataSource<TableViewCell, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = SectionedDataSource<TableViewCell, String>(tableView: tableView, cellConfiguration: { (cell, item) -> () in
            cell.textLabel?.text = item
        })
        
        dataSource.sections = items
        tableView.dataSource = dataSource
    }
    
}
