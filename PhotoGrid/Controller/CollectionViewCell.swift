//
//  CollectionViewCell.swift
//  PhotoGrid
//
//  Created by Mohammed Ibrahim on 15/8/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var cellSpinner:
        UIActivityIndicatorView!
    var imageCache = NSCache<AnyObject, UIImage>()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellSpinner.startAnimating()
    }
    
   

}
