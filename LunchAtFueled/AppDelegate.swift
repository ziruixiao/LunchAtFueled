//
//  AppDelegate.swift
//  LunchAtFueled
//
//  Created by Felix Xiao on 10/28/15.
//  Copyright (c) 2015 Felix Xiao. All rights reserved.
//

import UIKit
import QuadratTouch
import AERecord
import CoreLocation
import CoreData
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            print( NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!)
            do {
                //Open the database so it can be accessed.
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
            NSUserDefaults.standardUserDefaults().setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            

            self.window?.tintColor = UIColor(red: 71.0/255.0, green: 57.0/255.0, blue: 151.0/255.0, alpha: 1.0)
            Connection.sharedInstance.setupClient()
            
            
            let location = CLLocation(latitude: 40.724280, longitude: -73.997354)
            
            let parameters = location.parameters()
            Connection.sharedInstance.getVenuesFromLocation(parameters)
            return true
    }
    
    func application(application: UIApplication, openURL url: NSURL,
        sourceApplication: String?, annotation: AnyObject) -> Bool {
            return Session.sharedSession().handleURL(url)
    }
    
}

