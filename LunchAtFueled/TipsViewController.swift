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
        
        loadTips()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        Connection.sharedInstance.getTipsFromVenue(venue.id)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTips", name: "TipsLoaded", object: nil)
    }
    
    func loadTips() {
        if let currentTips = Tip.allWithAttribute("venueId", value: venue.id, sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)]) {
            allTips = currentTips as! [Tip]
        } else {
            allTips = [Tip]()
        }
    }
    
    func updateTips() {
        loadTips()
        self.tableView.reloadData()
    }
    
    @IBAction func showNewTipPage() {
        // TODO: Segue to next screen
        let viewController = Storyboard.create("newTip") as! AddTipViewController
        viewController.venue = venue
        viewController.title = "Add New Tip"
        self.navigationController?.pushViewController(viewController, animated: true)
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
