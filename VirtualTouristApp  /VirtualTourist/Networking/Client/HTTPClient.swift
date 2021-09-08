//
//  HTTPClient.swift
//  VirtualTourist
//
//  Created by Gizem Boskan on 4.09.2021.
//

import UIKit
import CoreData

class HTTPClient {
    class func downloadImage(for pin: Pin, path: String, completion: @escaping (Data?, Error?) -> Void) {
        if let image = HTTPClient.isImageOnCache(for: pin, by: path) {
            DispatchQueue.main.async {
                completion(image, nil)
            }
        } else {
            HTTPClient.getImageOnline(by: path) { data, error in
                if error != nil {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                } else {
                    if let data = data {
                        DispatchQueue.main.async {
                            saveImageToCache(for: pin, id: path, imageData: data)
                            completion(data, nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil, nil)
                        }
                    }
                }
            }
        }
    }
    
    private class func saveImageToCache(for pin: Pin, id: String, imageData: Data) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let newPhoto = Photo(context: context)
        newPhoto.id = id
        newPhoto.imageData = imageData
        newPhoto.pin = pin
        pin.addToPhotos(newPhoto)
        try? context.save()
    }
    
    private class func isImageOnCache(for pin: Pin, by id: String) -> Data? {
        if let pinPhotos = pin.photos?.allObjects as? [Photo], let imageData = pinPhotos.first(where: { $0.id == id })?.imageData {
            return imageData
        }
        
        return nil
    }
    
    class func getImageOnline(by urlString: String, completion: @escaping (Data?, Error?) -> Void ) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                completion(data, error)
            }
            task.resume()
        }
    }
}
