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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            
            do {
                try AERecord.loadCoreDataStack()
            } catch {
                print(error)
            }
            
            self.window?.tintColor = UIColor(red: 71.0/255.0, green: 57.0/255.0, blue: 151.0/255.0, alpha: 1.0)
            Connection.sharedInstance.setupClient()
            
            
            let location = CLLocation(latitude: 40.724280, longitude: -73.997354)
            
            var parameters = location.parameters( )
            parameters["query"] = "restaurant"
            parameters["limit"] = "50"
            Connection.sharedInstance.getVenuesFromLocation(parameters)
            return true
    }
    
    func application(application: UIApplication, openURL url: NSURL,
        sourceApplication: String?, annotation: AnyObject) -> Bool {
            return Session.sharedSession().handleURL(url)
    }
    
}

