//
//  LocationPhoto.swift
//  VirtualTourist
//
//  Created by Gizem Boskan on 4.09.2021.
//

import Foundation

struct LocationPhoto: Codable {
    let title: String
    let remoteURL: URL?
    let id: String
    let dateTaken: String
    let height: Int?
    let width: Int?
    let owner: String
    let views: String
    let license: String
    var latitude: String
    var longitude: String
    var accuracy: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case remoteURL = "url_z"
        case id = "id"
        case dateTaken = "datetaken"
        case height = "height_z"
        case width = "width_z"
        case owner = "ownername"
        case views
        case license
        case latitude
        case longitude
        case accuracy
    }
}

