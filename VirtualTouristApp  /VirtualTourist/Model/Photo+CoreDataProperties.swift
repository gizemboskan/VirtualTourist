//
//  Photo+CoreDataProperties.swift
//  Photo
//  VirtualTourist
//
//  Created by Gizem Boskan on 4.09.2021.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var id: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var pin: Pin?

}

extension Photo : Identifiable {

}
