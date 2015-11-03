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
    
    func setupClient() {
        let client = Client(clientID: clientID, clientSecret: clientSecret, redirectURL: redirectURL)
        var configuration = Configuration(client: client)
        configuration.mode = "foursquare"
        configuration.shouldControllNetworkActivityIndicator = true
        Session.setupSharedSessionWithConfiguration(configuration)
        session = Session.sharedSession()
    }
    
    func isLoggedIn() -> Bool {
        if (session.isAuthorized()) {
            return true;
        }
        return false;
    }
    
    func getVenuesFromLocation(parameters: Parameters) {
        var newParameters = parameters
        newParameters["query"] = "restaurant"
        newParameters["limit"] = "50"
        let task = self.session.venues.search(newParameters) {
            (result) -> Void in
            if result.response != nil {
                if let venues = result.response!["venues"] as? [[String: AnyObject]]  {
                    Venue.process(venues)
                    
                }
            }
        }
        task.start()
    }
    
    func getTipsFromVenue(venueId: String) {
        let task = self.session.venues.tips(venueId, parameters: nil) {
            (result) -> Void in
            if result.response != nil {
                
                if var tips = result.response!["tips"]!["items"] as? [[String: AnyObject]]  {
                    tips.append(["venueId": venueId])
                    Tip.process(tips)
                    
                }
            }
        }
        task.start()
    }
    
    
}