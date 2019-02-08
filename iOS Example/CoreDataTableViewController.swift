//
//  CoreDataTableViewController.swift
//  KWDataSourceKit
//
//  Created by Mathias Nagler on 26.01.16.
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import UIKit
import KWDataSourceKit
import CoreData

class CoreDataTableViewController: UITableViewController {
    
    private var dataSource: CoreDataSource<TableViewCell, Entity>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME: This cast should not be necessary
        let fetchRequest = Entity.fetchRequest() as! NSFetchRequest<Entity>
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        dataSource = CoreDataSource<TableViewCell, Entity>(fetchRequest: fetchRequest, inContext: CoreData.sharedController.mainContext, tableView: tableView, cellConfiguration: { (cell, item) -> () in
            cell.textLabel?.text = item.title
        })
        
        tableView.dataSource = dataSource
        dataSource.paused = false
    }
    
}
