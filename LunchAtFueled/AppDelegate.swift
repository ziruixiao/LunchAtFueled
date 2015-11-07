//
//  AppDelegate.swift
//  LunchAtFueled
//
//  Created by Felix Xiao on 10/28/15.
//  Copyright (c) 2015 Felix Xiao. All rights reserved.
//

import AERecord
import CoreData
import CoreLocation
import QuadratTouch
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            
            // NOTE: Uncomment the line below to access the Documents folder
            //print(NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!)
            
            // Open the database so it can be accessed, accounting for versioning
            do {
                let modelURL = NSBundle.mainBundle().URLForResource("LunchAtFueled", withExtension: "momd")
                let myStoreType = NSSQLiteStoreType
                let myStoreURL = AERecord.storeURLForName("LunchAtFueled")
                let myOptions = [NSMigratePersistentStoresAutomaticallyOption : true,NSInferMappingModelAutomaticallyOption : true]
                if let model = NSManagedObjectModel(contentsOfURL:modelURL!) {
                    try AERecord.loadCoreDataStack(managedObjectModel: model, storeType: myStoreType, configuration: nil, storeURL: myStoreURL, options: myOptions)
                }
            } catch {
                print(error)
            }
            
            // TODO: UIConstraint warnings are suppressed for now.
            NSUserDefaults.standardUserDefaults().setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            
            // initial window UI setup
            self.window?.tintColor = UIColor(red: 71.0/255.0, green: 57.0/255.0, blue: 151.0/255.0, alpha: 1.0)
            
            // initial Foursquare API connection
            Connection.sharedInstance.setupClient()
            
            return true
    }
    
}

