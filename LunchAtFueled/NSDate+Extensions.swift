//
//  NSDate+Extensions.swift
//  LunchAtFueled
//
//  Created by Felix Xiao on 11/6/15.
//  Copyright © 2015 Felix Xiao. All rights reserved.
//

import Foundation

extension NSDate {
    func timeAgoSinceDateWithNumeric(numericDates:Bool) -> String {
        let calendar = NSCalendar.currentCalendar()
        let unitFlags: NSCalendarUnit = [NSCalendarUnit.Minute, NSCalendarUnit.Hour, NSCalendarUnit.Day, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.Second]
        
        var inFuture : Bool = false
        
        let now = NSDate()
        if (self.isGreaterThanDate(now)) {
            //future date
            inFuture = true
        }
        
        let earliest = now.earlierDate(self)
        let latest = (earliest == now) ? self : now
        let components:NSDateComponents = calendar.components(unitFlags, fromDate: earliest, toDate: latest, options: [])
        
        if (components.year >= 2) {
            if (inFuture) {
                return "in \(components.year) years"
            } else {
                return "\(components.year) years ago"
            }
        } else if (components.year >= 1){
            if (inFuture) {
                if (numericDates){
                    return "in 1 year"
                } else {
                    return "next year"
                }
            } else {
                if (numericDates){
                    return "1 year ago"
                } else {
                    return "last year"
                }
            }
        } else if (components.month >= 2) {
            if (inFuture) {
                return "in \(components.month) months"
            } else {
                return "\(components.month) months ago"
            }
        } else if (components.month >= 1){
            if (inFuture) {
                if (numericDates){
                    return "in 1 month"
                } else {
                    return "next month"
                }
            } else {
                if (numericDates){
                    return "1 month ago"
                } else {
                    return "last month"
                }
            }
        } else if (components.weekOfYear >= 2) {
            if (inFuture) {
                return "in \(components.weekOfYear) weeks"
            } else {
                return "\(components.weekOfYear) weeks ago"
            }
        } else if (components.weekOfYear >= 1){
            if (inFuture) {
                if (numericDates){
                    return "in 1 week"
                } else {
                    return "next week"
                }
            } else {
                if (numericDates){
                    return "1 week ago"
                } else {
                    return "last week"
                }
            }
        } else if (components.day >= 2) {
            if (inFuture) {
                return "in \(components.day) days"
            } else {
                return "\(components.day) days ago"
            }
        } else if (components.day >= 1){
            if (inFuture) {
                if (numericDates){
                    return "in 1 day"
                } else {
                    return "next day"
                }
            } else {
                if (numericDates){
                    return "1 day ago"
                } else {
                    return "yesterday"
                }
            }
        } else if (components.hour >= 2) {
            if (inFuture) {
                return "in \(components.hour) hours"
            } else {
                return "\(components.hour) hours ago"
            }
        } else if (components.hour >= 1){
            if (inFuture) {
                if (numericDates){
                    return "in 1 hour"
                } else {
                    return "next hour"
                }
            } else {
                if (numericDates){
                    return "1 hour ago"
                } else {
                    return "last hour"
                }
            }
        } else if (components.minute >= 2) {
            if (inFuture) {
                return "in \(components.minute) min"
            } else {
                return "\(components.minute) min ago"
            }
        } else if (components.minute >= 1){
            if (inFuture) {
                if (numericDates){
                    return "in 1 min"
                } else {
                    return "next min"
                }
            } else {
                if (numericDates){
                    return "1 min ago"
                } else {
                    return "last min"
                }
            }
        } else if (components.second >= 3) {
            if (inFuture) {
                return "in \(components.second) sec"
            } else {
                return "\(components.second) sec ago"
            }
        } else {
            return " just now"
        }
        
    }
    
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool
    {
        var isGreater = false
        
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
        {
            isGreater = true
        }
        
        return isGreater
    }

}