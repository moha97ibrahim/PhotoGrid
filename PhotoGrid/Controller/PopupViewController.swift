//
//  PopupViewController.swift
//  PhotoGrid
//
//  Created by Mohammed Ibrahim on 15/8/21.
//

import UIKit


class PopupViewController: UIViewController {

    // MARK: Interface Builder
    @IBOutlet weak var image: UIImageView!
    @IBOutlet var popupBackground: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var grayView: UIView!
    
    // MARK: Variables
    var Url : String?
    var data : ImageDatatoKV?
    var indexAt : Int?
    var imageCache = NSCache<AnyObject, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        spinner.startAnimating()
        
        if let _image = Url{ loadImage(image: _image) }
        
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        
        // MARK: Swipe Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        grayView.addGestureRecognizer(tap)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
              
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        popupView.addGestureRecognizer(leftSwipe)
        popupView.addGestureRecognizer(rightSwipe)
        
    }
    
    @objc func close() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Handles Swipe
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
          
        // MARK: Left Swipe
        if (sender.direction == .left) {
            
            if indexAt! < (data?.imageData.count)!-1 {
                indexAt! += 1
                print(indexAt!)
                loadImage(image: (data?.imageData[indexAt!].url)!)
            }
        }
        // MARK: Right Swipe
        if (sender.direction == .right) {
            if indexAt! > 0 {
                indexAt! -= 1
                print(indexAt!)
                loadImage(image: (data?.imageData[indexAt!].url)!)
            }
        }
    }
    
    
    // MARK: Update image for every event
    func loadImage(image : String){
        let url = URL(string: image)
        if let cachedImage = self.imageCache.object(forKey: url as AnyObject){
            print("image loaded from cache")
            self.image.image = cachedImage
            spinner.stopAnimating()
            spinner.hidesWhenStopped = true
            return
        }
        print("image ldownloaded from server")
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.image.image = UIImage(data: data!)
                if let images = UIImage(data: data!){
                self.imageCache.setObject(images, forKey: url as AnyObject )
                    self.spinner.stopAnimating()
                    self.spinner.hidesWhenStopped = true
                }
            }
        }
    }
}
