//
//  PinAnnotation.swift
//  Virtual Tourist
//
//  Created by Mac User on 6/21/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation
import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var pin: Pin
    
    init(coordinate: CLLocationCoordinate2D, pin: Pin) {
        self.coordinate = coordinate
        self.pin = pin
    }
}
