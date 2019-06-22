//
//  PhotoResponse.swift
//  Virtual Tourist
//
//  Created by Mac User on 6/20/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation

struct SearchPhotoResponse {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.owner = dictionary["owner"] as? String ?? ""
        self.secret = dictionary["secret"] as? String ?? ""
        self.server = dictionary["server"] as? String ?? ""
        self.farm = dictionary["farm"] as? Int ?? 0
    }
    
    var url: URL? {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg") ?? nil
    }
}
