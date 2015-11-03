//
//  APIModel.swift
//  LunchAtFueled
//
//  Created by Felix Xiao on 10/30/15.
//  Copyright © 2015 Felix Xiao. All rights reserved.
//

import Foundation

protocol APIModel {
    static func process(records: [[String:AnyObject]])
    
    func store(record: [String: AnyObject])
}