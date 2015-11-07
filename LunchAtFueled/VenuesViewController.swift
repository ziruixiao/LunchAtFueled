//
//  VenuesViewController.swift
//  LunchAtFueled
//
//  Created by Felix Xiao on 10/30/15.
//  Copyright © 2015 Felix Xiao. All rights reserved.
//

import UIKit
import CoreLocation
import AERecord
import QuadratTouch

class VenuesViewController: UITableViewController, CLLocationManagerDelegate, SessionAuthorizationDelegate {
    
    var allVenues: [Venue]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadVenues()
        
        definesPresentationContext = true
        
        tableView.rowHeight = 120
        
        exploreVenues()
        self.navigationItem.leftBarButtonItem?.title = "Reset"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateVenues", name: "VenuesLoaded", object: nil)
        
    }
    func loadVenues() {
        if let currentVenues = Venue.allWithAttribute("hidden", value: false, sortDescriptors: [NSSortDescriptor(key: "distance", ascending: true)]) {
            allVenues = currentVenues as! [Venue]
        } else {
            allVenues = [Venue]()
        }
    }
    
    func updateVenues() {
        loadVenues()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func exploreVenues() {
        //if var location = self.locationManager.location {
        let location = CLLocation(latitude: 40.724280, longitude: -73.997354)

        let parameters = location.parameters()
        Connection.sharedInstance.getVenuesFromLocation(parameters)
    }
    
    @IBAction func resetButtonTapped() {
        Venue.batchUpdate(properties: ["hidden" : false])
        updateVenues()

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Venue.countWithAttribute("hidden", value: false)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("venueCell", forIndexPath: indexPath)
            as! VenueTableViewCell
        let item = self.allVenues[indexPath.row]
        self.configureCellWithItem(cell, item: item)
        return cell
    }
    
    
    func configureCellWithItem(cell:VenueTableViewCell, item: Venue) {
        
        cell.venueNameLabel.text = item.name
        cell.venueRatingLabel.text = String(item.distance) + " mi"
        cell.venueCommentLabel.text = String(item.tips) + " tips"
        cell.ratingView.rating = item.rating/2.0
        cell.ratingsCountView.text = "(" + String(item.ratingsCount) + ")"
        
    }
    
    override func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
            let cell = cell as! VenueTableViewCell
            if let photoURL = self.allVenues[indexPath.row].photoURL {
                let URL = NSURL(string: photoURL)
            if let imageData = Connection.sharedInstance.session.cachedImageDataForURL(URL!)  {
                cell.userPhotoImageView.image = UIImage(data: imageData)
            } else {
                cell.userPhotoImageView.image = nil
                Connection.sharedInstance.session.downloadImageAtURL(URL!) {
                    (imageData, error) -> Void in
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as? VenueTableViewCell
                    if cell != nil && imageData != nil {
                        let image = UIImage(data: imageData!)
                        cell!.userPhotoImageView.image = image
                    }
                }
                }
            }
        }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        openVenue(allVenues[indexPath.row])
    }
    
    
    func openVenue(venue: Venue) {
        let viewController = Storyboard.create("venueDetails") as! TipsViewController
        viewController.venue = venue
        viewController.title = venue.name
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func sessionWillPresentAuthorizationViewController(controller: AuthorizationViewController) {
        print("Will present authorization view controller.")
    }
    
    func sessionWillDismissAuthorizationViewController(controller: AuthorizationViewController) {
        print("Will disimiss authorization view controller.")
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let alert = UIAlertController(title: "Are you sure?", message: "This venue won't appear again unless you press the 'Reset' button.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    // "delete" the venue
                    let toHide = self.allVenues[indexPath.row]
                    toHide.hidden = true
                    AERecord.saveContext()
                    self.allVenues.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    break
                    
                case .Cancel:
                    print("cancel")
                    break
                    
                case .Destructive:
                    print("")
                    break
                }
            }))
            
            //numbers.removeAtIndex(indexPath.row)
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
   
}




class Storyboard: UIStoryboard {
    class func create(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(name)
    }
}

