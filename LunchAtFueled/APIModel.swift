//
//  APIModel.swift
//  LunchAtFueled
//
//  Created by Felix Xiao on 10/30/15.
//  Copyright © 2015 Felix Xiao. All rights reserved.
//

import Foundation

protocol APIModel {
    
    /// Takes in JSON records and initializes CoreData objects
    static func process(records: [[String:AnyObject]])
    
    /// Stores necessary variables by parsing JSON data for individual record
    func store(record: [String: AnyObject])
}