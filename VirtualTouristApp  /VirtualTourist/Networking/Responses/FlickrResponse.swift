//
//  FlickrResponse.swift
//  VirtualTourist
//
//  Created by Gizem Boskan on 4.09.2021.
//

import Foundation

struct FlickrPhotosInfoResponse: Codable {
    let photosInfo: FlickrPhotosResponse
    
    enum CodingKeys: String, CodingKey {
        case photosInfo = "photos"
    }
}
