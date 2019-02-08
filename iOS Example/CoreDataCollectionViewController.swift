//
//  CoreDataCollectionViewController.swift
//  KWDataSourceKit
//
//  Created by Mathias Nagler on 26.01.16.
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import UIKit
import KWDataSourceKit
import CoreData

class CoreDataCollectionViewController: UICollectionViewController {
    
    private var dataSource: CoreDataSource<CollectionViewCell, Entity>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME: This cast should not be necessary
        let fetchRequest = Entity.fetchRequest() as! NSFetchRequest<Entity>
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        dataSource = CoreDataSource<CollectionViewCell, Entity>(fetchRequest: fetchRequest, inContext: CoreData.sharedController.mainContext, collectionView: collectionView, cellConfiguration: { (cell, item) -> () in
            cell.label.text = item.title
        })
        
        collectionView?.dataSource = dataSource
        dataSource.paused = false
    }
    
}
