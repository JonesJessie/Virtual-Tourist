//
//  MapState.swift
//  Virtual Tourist
//
//  Created by Mac User on 6/21/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation

struct MapState: Codable {
    var longitude: Double
    var latitude: Double
    var longitudeDelta: Double
    var latitudeDelta: Double
}
