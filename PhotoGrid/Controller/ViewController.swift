//
//  ViewController.swift
//  PhotoGrid
//
//  Created by Mohammed Ibrahim on 14/8/21.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,ImageDataDelegate {

    // MARK: Interface Builder
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: Variables
    var imageManager = ImageManager()
    var data : ImageDatatoKV?
    var itemCount = 0
    var currentUrl : String?
    var indexAt : Int?
    var imageCache = NSCache<AnyObject, UIImage>()
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(
      top: 2.0,
      left: 2.0,
      bottom: 2.0,
      right: 2.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        spinner.startAnimating()
        imageManager.imageDelegate = self
        
        // MARK: Navigation Bar
        title = "Photo Grid"
        navBar.prefersLargeTitles = true
        
        
        // MARK: Collection View
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        collectionView.allowsSelection = true
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
               layout.minimumLineSpacing = 2
               layout.minimumInteritemSpacing = 2
               layout.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
               let size = CGSize(width:(collectionView!.bounds.width)/4, height: (collectionView!.bounds.width)/4)
               layout.itemSize = size
           }
    
        // MARK: Fetch Data
        imageManager.fetchData()
       
    }
    
    // MARK: - Collection View Flow Layout Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell

        if let image = data?.imageData[indexPath.row].url {
            let url = URL(string: image)
            if let cachedImage = self.imageCache.object(forKey: url as AnyObject){
                cell.image.image = cachedImage
                return cell
            }
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                //print("image downloaded from serve\(indexPath.row)")
                DispatchQueue.main.async {
                    cell.image.image = UIImage(data: data!)
                    if let images = UIImage(data: data!){
                        self.onLoaded(image: images, url: url as AnyObject, cell: cell)
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "PopupViewController"){
            navigationController?.pushViewController(vc, animated: true)
        }
        currentUrl = data?.imageData[indexPath.row].url
        indexAt = indexPath.row
        let segues = ["popup"]
               let segueID = segues[0]
               performSegue(withIdentifier: segueID, sender: self)
        
        print(indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
       {
           if segue.destination is PopupViewController {
               let vc = segue.destination as? PopupViewController
            vc?.Url = self.currentUrl
            vc?.data =  self.data
            vc?.indexAt = self.indexAt
           }
           
       }
 
    // MARK: Update Data
    func didUpdateImageData(data: ImageDatatoKV) {
        DispatchQueue.main.async {
        self.data = data
        self.itemCount = data.imageData.count
        print(data.imageData.count)
            self.collectionView.reloadData()
            self.spinner.stopAnimating()
            self.spinner.hidesWhenStopped = true
        }
    }
    
    // MARK: onLoaded
    func onLoaded(image : UIImage , url : AnyObject, cell : CollectionViewCell) {
        self.imageCache.setObject(image, forKey: url as AnyObject )
            cell.cellSpinner.stopAnimating()
            cell.cellSpinner.hidesWhenStopped = true
    }
}

// MARK: - Collection View Flow Layout Delegate
extension ViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {

    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return sectionInsets
  }
  

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return sectionInsets.left
  }
}

