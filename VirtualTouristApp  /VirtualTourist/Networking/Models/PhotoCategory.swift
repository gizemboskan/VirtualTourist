//
//  PhotoCategory.swift
//  VirtualTourist
//
//  Created by Gizem Boskan on 4.09.2021.
//

import Foundation

enum PhotoCategory: String {
    case favorites
    case interestingness
    case nearBy
    case notSelected
    case popular
    case recent

    var id: String { rawValue }
}
