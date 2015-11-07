//
//  CLLocation+Extensions.swift
//  LunchAtFueled
//
//  Created by Felix Xiao on 11/7/15.
//  Copyright © 2015 Felix Xiao. All rights reserved.
//

import Foundation
import CoreLocation
import QuadratTouch

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