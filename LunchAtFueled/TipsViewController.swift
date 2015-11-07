//
//  TipsViewController.swift
//  LunchAtFueled
//
//  Created by Felix Xiao on 10/30/15.
//  Copyright © 2015 Felix Xiao. All rights reserved.
//

import Foundation
import QuadratTouch
import UIKit

class TipsViewController: UITableViewController {
    
    var allTips: [Tip]!
    var venue: Venue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTips()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        // load the tips for the selected venue from the API
        Connection.sharedInstance.getTipsFromVenue(venue.id)
        
        // observe tips loading to refresh tips table upon API download
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTips", name: "TipsLoaded", object: nil)
    }
    
    /// Load tips from CoreData context
    func loadTips() {
        if let currentTips = Tip.allWithAttribute("venueId", value: venue.id, sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)]) {
            allTips = currentTips as! [Tip]
        } else {
            allTips = [Tip]()
        }
    }
    
    /// Loads tips again before calling refresh on table view
    func updateTips() {
        loadTips()
        self.tableView.reloadData()
    }
    
    /// Advance to new tip page
    @IBAction func showNewTipPage() {
        let viewController = Storyboard.create("newTip") as! AddTipViewController
        viewController.venue = venue
        viewController.title = "Add New Tip"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Table View Delegate and Data Source
    
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
