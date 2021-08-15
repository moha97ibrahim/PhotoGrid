//
//  PopupViewController.swift
//  PhotoGrid
//
//  Created by Mohammed Ibrahim on 15/8/21.
//

import UIKit


class PopupViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet var popupBackground: UIView!
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var grayView: UIView!
    var Url : String?
    var data : ImageDatatoKV?
    var indexAt : Int?
    var imageCache = NSCache<AnyObject, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        spinner.startAnimating()
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        grayView.addGestureRecognizer(tap)
        
        if let _image = Url{
            loadImage(image: _image)
        }
        
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

    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
            
        if (sender.direction == .left) {
            
            if indexAt! < (data?.imageData.count)!-1 {
                indexAt! += 1
                print(indexAt!)
                loadImage(image: (data?.imageData[indexAt!].url)!)
            }
        }
            
        if (sender.direction == .right) {
            if indexAt! > 0 {
                indexAt! -= 1
                print(indexAt!)
                loadImage(image: (data?.imageData[indexAt!].url)!)
            }
        }
    }
    
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
