//
//  Connection.swift
//  LunchAtFueled
//
//  Created by Felix Xiao on 10/29/15.
//  Copyright © 2015 Felix Xiao. All rights reserved.
//

import Foundation
import QuadratTouch

class Connection {
    
    static let sharedInstance = Connection()
    
    let clientID = "EJULDHWJHGJ5CKHW2ESVNDMAQLITDEF5BVP0DK4E5JQTWH31";
    let clientSecret = "YAXPJJ3MWZCCIGKQOX34S3EXTL3BTST3IR3QJY4PHNMAWFVF";
    let redirectURL = "fsoauthexample://authorized";
    var session: Session!
    
    /// Initializes the Foursquare session that can be used in the whole app
    func setupClient() {
        let client = Client(clientID: clientID, clientSecret: clientSecret, redirectURL: redirectURL)
        var configuration = Configuration(client: client)
        configuration.mode = "foursquare"
        configuration.shouldControllNetworkActivityIndicator = true
        Session.setupSharedSessionWithConfiguration(configuration)
        session = Session.sharedSession()
    }
    
    /// Takes in parameters and gets the 50 closest recommended venues from those parameters
    func getVenuesFromLocation(parameters: Parameters) {
        var newParameters = parameters
        newParameters["section"] = "food"
        newParameters["limit"] = "50"
        newParameters["sortByDistance"] = "1"
        newParameters["venuePhotos"] = "1"
        let task = self.session.venues.explore(newParameters) {
            (result) -> Void in
            if result.response != nil {
                if let groups = result.response!["groups"] as? [[String: AnyObject]]  {
                    if let items = groups[0]["items"] as? [[String: AnyObject]] {
                        Venue.process(items) // send JSON data to static APIModel function
                    }
                }
            }
            
            // post a notification that venues have been loaded from the API
            NSNotificationCenter.defaultCenter().postNotificationName("VenuesLoaded", object: nil)
        }
        task.start()
    }
    
    /// Takes in a venue id and loads the tips associated with it.
    func getTipsFromVenue(venueId: String) {
        let task = self.session.venues.tips(venueId, parameters: nil) {
            (result) -> Void in
            if result.response != nil {
                if var tips = result.response!["tips"]!["items"] as? [[String: AnyObject]]  {
                    tips.append(["venueId": venueId])
                    Tip.process(tips) // send JSON data to static APIModel function
                }
            }
    
            // post a notification that tips have been loaded from the API
            NSNotificationCenter.defaultCenter().postNotificationName("TipsLoaded", object: nil)
        }
        task.start()
    }
    
    
}