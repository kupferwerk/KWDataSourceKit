//
//  AppDelegate.swift
//  KWDataSouce iOS Example
//
//  Created by Mathias Nagler on 24.01.16.
//  Copyright © 2016 Kupferwerk GmbH. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        seedSampleData()
        return true
    }

    private func seedSampleData() {
        for i in 1...50 {
            let context = CoreData.sharedController.mainContext
            let entity = context.insert(Entity)
            entity.title = "Test \(i)"
        }
        
        CoreData.sharedController.save()
    }
    
}

