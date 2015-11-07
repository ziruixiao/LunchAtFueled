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
    @NSManaged var distance: Double
    @NSManaged var id: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var name: String
    @NSManaged var checkins: Int
    @NSManaged var tips: Int
    @NSManaged var rating: Double
    @NSManaged var ratingsCount: Int
    @NSManaged var hidden: Bool
    
    // optional fields
    @NSManaged var photoURL: String?
    
    
    
    static func process(records: [[String:AnyObject]]) {
        for record in records {
            if let recordInfo = record["venue"] as? [String: AnyObject] {
                if let recordID = recordInfo["id"] {
                    let newVenue = Venue.firstOrCreateWithAttribute("id", value: recordID) as! Venue
                    // TODO: Call this upon page load in ViewController
                    // Connection.sharedInstance.getTipsFromVenue(recordID as! String)
                    newVenue.store(recordInfo)
                }
            }
        }
    }
    
    func store(record: [String: AnyObject]) {
        if let recordName = record["name"] as? String {
            name = recordName
        }
        
        if let location = record["location"] as? [String:AnyObject] {
            if let recordDistance = location["distance"] as? Double {
                distance = (recordDistance/1610).roundToPlaces(2)
            }
            
            if let recordLatitude = location["lat"] as? Double {
                latitude = recordLatitude
            }
            
            if let recordLongitude = location["lng"] as? Double {
                longitude = recordLongitude
            }
            
            if let recordAddress = location["formattedAddress"] as? [String] {
                address = recordAddress[0]
            }
        }
        
        if let recordRating = record["rating"] as? Double {
            rating = recordRating
        }
        
        if let recordRatingsCount = record["ratingSignals"] as? Int {
            ratingsCount = recordRatingsCount
        }
        
        
        
        if let photos = record["photos"] as? [String: AnyObject] {
            if let photoGroups = photos["groups"]![0] as? [String: AnyObject] {
                if let photoItems = photoGroups["items"] as? [[String: AnyObject]] {
                    let photoItem = photoItems[0]
                    var recordPhotoURL = ""
                    if let iconPrefix = photoItem["prefix"] as? String {
                        recordPhotoURL = iconPrefix
                    }
                    recordPhotoURL += "100x100"
                    if let iconSuffix = photoItem["suffix"] as? String {
                        recordPhotoURL += iconSuffix
                    }
                    photoURL = recordPhotoURL
                }
            }
            
        }
        
        if let stats = record["stats"] as? [String: AnyObject] {
            if let recordCheckins = stats["checkinsCount"] as? Int {
                checkins = recordCheckins
            }
            
            if let recordTips = stats["tipCount"] as? Int {
                tips = recordTips
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