//
//  FlickrPhotosResponse.swift
//  VirtualTourist
//
//  Created by Gizem Boskan on 4.09.2021.
//

import Foundation

struct FlickrPhotosResponse: Codable {
    let photos: [LocationPhoto]
    
    enum CodingKeys: String, CodingKey {
        case photos = "photo"
    }
}
