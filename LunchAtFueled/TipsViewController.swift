//
//  TipsViewController.swift
//  LunchAtFueled
//
//  Created by Felix Xiao on 10/30/15.
//  Copyright © 2015 Felix Xiao. All rights reserved.
//

import Foundation
import UIKit

import QuadratTouch

/** Shows tips related to a venue. */
class TipsViewController: UITableViewController {
    var allTips: [Tip]!
    var venue: Venue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentTips = Tip.allWithAttribute("venueId", value: venue.id, sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)]) {
            allTips = currentTips as! [Tip]
        } else {
            allTips = [Tip]()
        }
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        Connection.sharedInstance.getTipsFromVenue(venue.id)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.allTips != nil {
            return self.allTips!.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        let tip = self.allTips![indexPath.row]
        
        cell.textLabel?.text = tip.text
        cell.detailTextLabel?.text = tip.createdAt.timeAgoSinceDateWithNumeric(true)
        return cell
    }
}
