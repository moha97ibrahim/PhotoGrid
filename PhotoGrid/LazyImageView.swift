//
//  LazyImageView.swift
//  PhotoGrid
//
//  Created by Mohammed Ibrahim on 15/8/21.
//

import Foundation
import UIKit

class LazyImageView : UIImageView
{
    func loadIamge(fromURL imageURL: URL){
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: imageURL){
                if let image = UIImage(data: imageData){
                    DispatchQueue.global().async {
                        self.image = image 
                    }
                }
            }
        }
    }
}
