//
//  Venue.swift
//  LunchAtFueled
//
//  Created by Felix Xiao on 10/30/15.
//  Copyright © 2015 Felix Xiao. All rights reserved.
//

import Foundation
import CoreData
import AERecord

@objc(Venue)
class Venue : NSManagedObject {
    
    // required fields
    @NSManaged var address: String
    @NSManaged var checkins: Int
    @NSManaged var distance: Double
    @NSManaged var id: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var name: String
    @NSManaged var facebook:String?

    // optional fields
    @NSManaged var phone: String?
    @NSManaged var photoURL: String?
    @NSManaged var twitter: String?
    
    
    static func process(records: [[String:AnyObject]]) {
        for record in records {
            if let recordID = record["id"] {
                let newVenue = Venue.firstOrCreateWithAttribute("id", value: recordID) as! Venue
                Connection.sharedInstance.getTipsFromVenue(recordID as! String)
                newVenue.store(record)
            }
        }
    }
    
    func store(record: [String: AnyObject]) {
        if let recordName = record["name"] as? String {
            name = recordName
        }
        
        if let location = record["location"] as? [String:AnyObject] {
            if let recordDistance = location["distance"] as? Double {
                distance = recordDistance
            }
            
            if let recordLatitude = location["lat"] as? Double {
                latitude = recordLatitude
            }
            
            if let recordLongitude = location["lng"] as? Double {
                longitude = recordLongitude
            }
            
            if let recordAddress = location["formattedAddress"] as? String {
                address = recordAddress
            }
        }
        
        if let contact = record["contact"] as? [String: AnyObject] {
            if let recordPhone = contact["phone"] as? String? {
                phone = recordPhone
            }
        }
        
        if let recordFacebook = record["facebook"] as? String {
            facebook = recordFacebook
        }
        
        if let recordTwitter = record["twitter"] as? String {
            twitter = recordTwitter
        }
        
        if let categories = record["categories"]![0] as? [String: AnyObject] {
            
            if let icon = categories["icon"] as? [String:AnyObject] {
                var recordPhotoURL = ""
                if let iconPrefix = icon["prefix"] as? String {
                    recordPhotoURL = iconPrefix
                }
                recordPhotoURL += "100x100"
                if let iconSuffix = icon["suffix"] as? String {
                    recordPhotoURL += iconSuffix
                }
                photoURL = recordPhotoURL
            }
        }
        
        if let stats = record["stats"] as? [String: AnyObject] {
            if let recordCheckins = stats["checkinsCount"] as? Int {
                checkins = recordCheckins
            }
        }
        AERecord.saveContext()
        //print(record)
        /*
        print(record["id"])
        print(record["name"])
        print(record["location"]!["distance"])
        print(record["location"]!["lat"])
        print(record["location"]!["lng"])
        print(record["contact"]!["phone"])
        print(record["facebook"]) //www.facebook.com/VALUE
        print(record["twitter"]) //www.twitter.com/VALUE
        print(record["location"]!["formattedAddress"])
        print(record["categories"]!["icon"]!!["prefix"]) //photoURL
        print(record["categories"]!["icon"]!!["suffix"]) //.png
        print(record["stats"]!["checkinsCount"]) // number of check ins
        */
    }
    
}