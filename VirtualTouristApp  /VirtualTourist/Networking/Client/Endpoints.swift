//
//  Endpoints.swift
//  VirtualTourist
//
//  Created by Gizem Boskan on 4.09.2021.
//

import Foundation

enum Endpoints {
    static let base = "https://api.flickr.com/services/rest"
    static let secretKey = "0d7bf319090081a0"
}

enum EndPoint: String {
    case locationPhotos = "flickr.photos.search"
}
