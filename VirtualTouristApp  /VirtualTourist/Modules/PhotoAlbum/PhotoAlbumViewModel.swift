//
//  PhotoAlbumViewModel.swift
//  VirtualTourist
//
//  Created by Gizem Boskan on 4.09.2021.
//

import Foundation
import MapKit
import CoreData

protocol PhotoAlbumViewModelDelegate: AnyObject {
    func photosLoaded()
    func zoomRegion(region: MKCoordinateRegion)
    func pinLoaded()
    func getMorePhotos()
    func showEmptyView()
}

protocol PhotoAlbumViewModelProtocol {
    var delegate: PhotoAlbumViewModelDelegate? { get set }
    var photos: [PhotoModel] { get set }
    var selectedPin: Pin? { get set}
    var currentPage: Int { get set}
    func getPhotos(_ pageNumber: Int)
    func pinArrived()
    func loadMorePhotos()
}

final class PhotoAlbumViewModel {
    
    weak var delegate: PhotoAlbumViewModelDelegate?
    var selectedPin: Pin?
    var photos: [PhotoModel] = []
    var currentPage: Int = 1
    
    private func dowloadImage(_ pageNumber: Int)  {
        guard  let selectedPin = selectedPin  else {return}
        selectedPin.photos = nil
        FlickrClient.getFlickrPhotos(page: pageNumber, latitude: String(selectedPin.lat), longitude: String(selectedPin.long)) { response, error in
            self.photos = response?.photosInfo.photos.map{ PhotoModel(imageUrlString: $0.remoteURL?.absoluteString)} ?? []
            if self.photos.isEmpty {
                self.delegate?.showEmptyView()
            }
            self.delegate?.photosLoaded()
        }
    }
}

extension PhotoAlbumViewModel: PhotoAlbumViewModelProtocol{
    
    func loadMorePhotos(){
        if currentPage <= 100 {
            currentPage += 1
            dowloadImage(currentPage)
            delegate?.getMorePhotos()
        }
    }
    func pinArrived(){
        if selectedPin == selectedPin {
            delegate?.pinLoaded()
        }
    }
    func getPhotos(_ pageNumber: Int) {
        guard  let selectedPin = selectedPin  else {return}
        
        if let pinPhotos = selectedPin.photos?.allObjects as? [Photo] , !pinPhotos.isEmpty {
            photos = pinPhotos.map { PhotoModel(imageUrlString: $0.id) }
            delegate?.photosLoaded()
        } else {
            dowloadImage(pageNumber)
        }
    }
    
}
