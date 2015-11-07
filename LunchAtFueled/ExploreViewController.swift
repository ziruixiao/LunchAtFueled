//
//  FirstViewController.swift
//  Demo-iOS
//
//  Created by Constantine Fry on 08/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import UIKit
import CoreLocation

import QuadratTouch

typealias JSONParameters = [String: AnyObject]

/** Shows result from `explore` endpoint. And has search controller to search in nearby venues. */
class ExploreViewController: UITableViewController, CLLocationManagerDelegate, SessionAuthorizationDelegate {
    var searchController: UISearchController!
    
    var locationManager : CLLocationManager!
    
    var allVenues: [Venue]!
    
    /** Number formatter for rating. */
    let numberFormatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentVenues = Venue.all([NSSortDescriptor(key: "distance", ascending: true)]) {
            allVenues = currentVenues as! [Venue]
        } else {
            allVenues = [Venue]()
        }
        
        numberFormatter.numberStyle = .DecimalStyle
        
        
        definesPresentationContext = true
        
        tableView.rowHeight = 120
        
        exploreVenues()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == CLAuthorizationStatus.AuthorizedWhenInUse
            || status == CLAuthorizationStatus.AuthorizedAlways {
                locationManager.startUpdatingLocation()
        } else {
            showNoPermissionsAlert()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateLeftBarButton()
    }
    
    private func updateLeftBarButton() {
        if Connection.sharedInstance.isLoggedIn() {
            self.navigationItem.leftBarButtonItem?.title = "Logout"
        } else {
            self.navigationItem.leftBarButtonItem?.title = "Login"
        }
    }
    
    
    func showNoPermissionsAlert() {
        let alertController = UIAlertController(title: "No permission",
            message: "In order to work, app needs your location", preferredStyle: .Alert)
        let openSettings = UIAlertAction(title: "Open settings", style: .Default, handler: {
            (action) -> Void in
            let URL = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.sharedApplication().openURL(URL!)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(openSettings)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert(error: NSError) {
        let alertController = UIAlertController(title: "Error",
            message:error.localizedDescription, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .Denied || status == .Restricted {
            showNoPermissionsAlert()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // Process error.
        // kCLErrorDomain. Not localized.
        showErrorAlert(error)
    }
    
    func locationManager(manager: CLLocationManager,
        didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
            if allVenues.count < 1 {
                exploreVenues()
            }
            locationManager.stopUpdatingLocation()
    }
    
    func exploreVenues() {
        //if var location = self.locationManager.location {
        let location = CLLocation(latitude: 40.724280, longitude: -73.997354)

        let parameters = location.parameters()
        Connection.sharedInstance.getVenuesFromLocation(parameters)
    }
    
    @IBAction func authorizeButtonTapped() {
        if Connection.sharedInstance.isLoggedIn() {
            Connection.sharedInstance.session.deauthorize()
            self.updateLeftBarButton()
            self.exploreVenues()
        } else {
            Connection.sharedInstance.session.authorizeWithViewController(self, delegate: self) {
                (authorized, error) -> Void in
                self.updateLeftBarButton()
                self.exploreVenues()
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Venue.count()
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
        let viewController = Storyboard.create("venueDetails") as! VenueTipsViewController
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
}

extension CLLocation {
    func parameters() -> Parameters {
        let ll      = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
        let llAcc   = "\(self.horizontalAccuracy)"
        let alt     = "\(self.altitude)"
        let altAcc  = "\(self.verticalAccuracy)"
        let parameters = [
            Parameter.ll:ll,
            Parameter.llAcc:llAcc,
            Parameter.alt:alt,
            Parameter.altAcc:altAcc
        ]
        return parameters
    }
}


class Storyboard: UIStoryboard {
    class func create(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(name)
    }
}
