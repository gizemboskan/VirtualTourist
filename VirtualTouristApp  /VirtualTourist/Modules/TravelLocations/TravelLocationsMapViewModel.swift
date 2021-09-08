//
//  TravelLocationsMapViewModel.swift
//  VirtualTourist
//
//  Created by Gizem Boskan on 4.09.2021.
//

import Foundation
import MapKit
import CoreData

protocol TravelLocationsMapViewModelDelegate: AnyObject {
    func pinsLoaded()
    func zoomRegion(region: MKCoordinateRegion)
}

protocol TravelLocationsMapViewModelProtocol {
    var delegate: TravelLocationsMapViewModelDelegate? { get set }
    var pins: [Pin] { get set }
    func setMapVisibleRegion(longitude: Double, latitude: Double)
    func loadCachedPins()
}

final class TravelLocationsMapViewModel: NSObject {
    weak var delegate: TravelLocationsMapViewModelDelegate?
    var pins = [Pin]()
}


extension TravelLocationsMapViewModel: TravelLocationsMapViewModelProtocol {
    func setMapVisibleRegion(longitude: Double, latitude: Double) {
        let latDelta:CLLocationDegrees = 2
        let lonDelta:CLLocationDegrees = 2
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let lat:CLLocationDegrees = latitude
        let long:CLLocationDegrees = longitude
        let location = CLLocation(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        
        self.delegate?.zoomRegion(region: region)
    }
    
    func loadCachedPins() {
        pins.removeAll()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let pinsReq: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let cachedPins = try? context.fetch(pinsReq) {
            self.pins = cachedPins
            delegate?.pinsLoaded()
        }
    }
    
}

