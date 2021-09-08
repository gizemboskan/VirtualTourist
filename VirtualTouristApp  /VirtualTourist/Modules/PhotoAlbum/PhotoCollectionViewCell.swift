//
//  PhotoCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Gizem Boskan on 4.09.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!{
        didSet{
            
            photoImageView.image = UIImage(named: "noImagePlaceholder")
        }
    }
    
    public func setImage(for pin: Pin, from urlString: String) {
        
        HTTPClient.downloadImage(for: pin, path: urlString){ data, error in
            DispatchQueue.main.async {
                guard let data = data else { return }
                self.photoImageView.image = UIImage(data: data)
            }
        }
    }
    
}
