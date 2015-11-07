//
//  Tip.swift
//  LunchAtFueled
//
//  Created by Felix Xiao on 11/3/15.
//  Copyright © 2015 Felix Xiao. All rights reserved.
//

import Foundation
import CoreData
import AERecord

@objc(Tip)
class Tip : NSManagedObject {
    
    // required fields
    @NSManaged var text: String
    @NSManaged var createdAt: NSDate
    @NSManaged var id: String
    @NSManaged var venueId: String
    
    static func process(records: [[String:AnyObject]]) {
        
        // in this case, we need to get the venueId and then drop it
        var updatedRecords = records
        let recordVenueId = updatedRecords.popLast()!["venueId"]
        for record in records {
            if let recordID = record["id"] {
                let newTip = Tip.firstOrCreateWithAttribute("id", value: recordID) as! Tip
                newTip.venueId = recordVenueId as! String
                newTip.store(record)
            }
        }
    }
    
    func store(record: [String: AnyObject]) {

        if let recordId = record["id"] as? String {
            id = recordId
        }
        
        if let recordText = record["text"] as? String {
            text = recordText
        }
        
        if let recordCreatedAt = record["createdAt"] as? Double {
            createdAt = NSDate(timeIntervalSince1970: NSTimeInterval(recordCreatedAt))
        }
        
        AERecord.saveContext()
    }
    
}