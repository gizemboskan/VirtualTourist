//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Gizem Boskan on 4.09.2021.
//

import UIKit
import MapKit
import CoreData
class TravelLocationsMapViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: TravelLocationsMapViewModel = TravelLocationsMapViewModel()
    var locationPins : [MKPointAnnotation] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // MARK: - UI Components
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        viewModel.delegate = self
        viewModel.loadCachedPins()
        
        // add gesture recognizer
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(mapLongPress(_:))) // colon needs to pass through info
        longPress.numberOfTouchesRequired = 1
        longPress.minimumPressDuration = 1.5 // in seconds
        mapView.addGestureRecognizer(longPress)
        viewModel.setMapVisibleRegion(longitude: 27.142826, latitude: 38.423733)
    }
    
    // MARK: - Helpers
    private func getAnnotations(){
        
        if !viewModel.pins.isEmpty {
            for location in viewModel.pins {
                let lat = CLLocationDegrees(location.lat)
                let long = CLLocationDegrees(location.long)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                addPinAnnotation(coordinate: coordinate)
                let annotation = TravelLocationMapAnnotation()
                annotation.coordinate = coordinate
                annotation.identifier = "\(location.id)"
                self.locationPins.append(annotation)
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.locationPins)
            }
        }
    }
    
    private func addPinAnnotation(coordinate: CLLocationCoordinate2D) {
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = coordinate
        mapView.addAnnotation(newAnnotation)
    }
        
    @objc func mapLongPress(_ recognizer: UIGestureRecognizer) {
        
        if recognizer.state == UIGestureRecognizer.State.ended {
            print("A long press has been detected.")
            
            let touchedAt = recognizer.location(in: self.mapView) // adds the location on the view it was pressed
            let touchedAtCoordinate : CLLocationCoordinate2D = mapView.convert(touchedAt, toCoordinateFrom: self.mapView) // will get coordinates
            
            let newPin = MKPointAnnotation()
            newPin.coordinate = touchedAtCoordinate
            mapView.addAnnotation(newPin)
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            
            let pin = Pin(context: context)
            pin.lat = newPin.coordinate.latitude
            pin.long = newPin.coordinate.longitude
            try? context.save()
            viewModel.loadCachedPins()
        }
    }
    
}
// MARK: - MKMapViewDelegate
extension TravelLocationsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "Pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.isEnabled = true
            pinView?.canShowCallout = false
            let btn = UIButton(type: .detailDisclosure)
            
            pinView?.rightCalloutAccessoryView = btn
        }else {
            pinView?.annotation = annotation
        }
        pinView?.pinTintColor = .purple
        pinView?.tintColor = .purple
        
        return pinView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let coordinate = view.annotation?.coordinate {
            
            if let vc = storyboard?.instantiateViewController(withIdentifier: "PhotoAlbumViewController") as? PhotoAlbumViewController {
                if let selectedPin = viewModel.pins.first(where: {$0.lat == coordinate.latitude && $0.long == coordinate.longitude}) {
                    vc.viewModel.selectedPin = selectedPin
                    
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
}


// MARK: - TravelLocationsMapViewModelDelegate
extension TravelLocationsMapViewController: TravelLocationsMapViewModelDelegate {
    func pinsLoaded() {
        getAnnotations()
    }
        
    
    func zoomRegion(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
    
}
