//
//  Network.swift
//  Virtual Tourist
//
//  Created by Mac User on 6/20/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation

class NetworkClient {
    
    static let apiKey = "cc26f14722697ae69ec523fe701e9784"
    
    enum Endpoints {
        case searchPhotosFor(latitude: Double, longitude: Double)
        
        var stringValue: String {
            switch self {
            case .searchPhotosFor(let latitude, let longitude):
                return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&lat=\(latitude)&lon=\(longitude)&format=json&nojsoncallback=1"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
}

    class func searchPhotosFor(latitude: Double, longitude: Double, completion: @escaping ([URL], Error?)-> Void) {
        let url = Endpoints.searchPhotosFor(latitude: latitude, longitude: longitude).url
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let photos = json["photos"] as? [String: Any] {
                    if let photo = photos["photo"] as? [[String: Any]] {
                        let searchPhotoPaths = photo.compactMap({ (dictionary) -> URL? in
                            let photoResponse = SearchPhotoResponse(dictionary: dictionary)
                            return photoResponse.url ?? nil
                        })
                        
                        if searchPhotoPaths.count < 15 {
                            DispatchQueue.main.async {
                                completion(searchPhotoPaths, nil)
                            }
                            return
                        } else {
                            var randomPhotoPaths: [URL] = []
                            for _ in 1...15 {
                                if let photoURL = searchPhotoPaths.randomElement() {
                                    randomPhotoPaths.append(photoURL)
                                }
                            }
                            DispatchQueue.main.async {
                                completion(randomPhotoPaths, nil)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion([],nil)
                    }
                }
            }
        }
        task.resume()
    }
}
