//
//  Double+Extensions.swift
//  LunchAtFueled
//
//  Created by Felix Xiao on 11/6/15.
//  Copyright © 2015 Felix Xiao. All rights reserved.
//

import Foundation

extension Double {
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
