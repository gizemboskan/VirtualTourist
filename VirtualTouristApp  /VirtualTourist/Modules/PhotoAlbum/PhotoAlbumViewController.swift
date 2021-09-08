//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Gizem Boskan on 4.09.2021.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {
    // MARK: - Properties
    var viewModel: PhotoAlbumViewModelProtocol = PhotoAlbumViewModel()
    
    // MARK: - UI Components
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        mapView.delegate = self
        viewModel.delegate = self
        viewModel.pinArrived()
        viewModel.getPhotos(viewModel.currentPage)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getPhotos(viewModel.currentPage)
    }
    
    // MARK: - Helpers
    
    @IBAction func newCollectionButtonAction(_ sender: UIButton) {
        viewModel.loadMorePhotos()
        photosCollectionView.isScrollEnabled = true
        
    }
    private func setMapAnnotation(){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: viewModel.selectedPin?.lat ?? 0, longitude: viewModel.selectedPin?.long ?? 0)
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        
    }
    func deleteData(index: Int){
        if let photo = viewModel.selectedPin?.photos?.first(where: { ($0 as? Photo)?.id ==  viewModel.photos[index].imageUrlString}) as? Photo {
            viewModel.selectedPin?.removeFromPhotos(photo)
            viewModel.photos.remove(at: index)
            photosCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource and Delegate
extension PhotoAlbumViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let photoModel = viewModel.photos[indexPath.row]
        
        if let urlString = photoModel.imageUrlString, let pin = viewModel.selectedPin {
            cell.setImage(for: pin, from: urlString)
            
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Delete?", message: "Do you want to delete this item?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete!" , style: .destructive, handler: { _ in
            self.deleteData(index: indexPath.row)
            self.photosCollectionView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
}
// MARK: - MKMapViewDelegate
extension PhotoAlbumViewController: MKMapViewDelegate {
    
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
    
    
}
extension PhotoAlbumViewController: PhotoAlbumViewModelDelegate{
    func showEmptyView() {
        DispatchQueue.main.async {
            self.photosCollectionView.setEmptyView(title: "no image!", message: "Oops! Nothing to show!")
        }
    }
    
    func pinLoaded() {
        setMapAnnotation()
    }
    
    func photosLoaded() {
        DispatchQueue.main.async {
            self.photosCollectionView.reloadData()
        }
    }
    
    func zoomRegion(region: MKCoordinateRegion) {
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
        }
    }
    func getMorePhotos() {
        DispatchQueue.main.async {
            self.photosCollectionView.reloadData()
        }
    }
}

