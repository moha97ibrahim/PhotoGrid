# PhotoGrid

App with NSCache, UICollectionView, MVC Pattern 

## CollectionView

CollectionViewLayout is used to display item per row


```bash
 // MARK: Collection View
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), 
               forCellWithReuseIdentifier: "CollectionCell")
        collectionView.allowsSelection = true
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
               layout.minimumLineSpacing = 2
               layout.minimumInteritemSpacing = 2
               layout.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
               let size = CGSize(width:(collectionView!.bounds.width)/4, height: (collectionView!.bounds.width)/4)
               layout.itemSize = size
           }
```

## NSCache

NSCache is used to store image url to avoid fetching again and again from server


```python
# variable
var imageCache = NSCache<AnyObject, UIImage>()


 if let image = data?.imageData[indexPath.row].url {
            let url = URL(string: image)

             # Check url already stored in the cache
            if let cachedImage = self.imageCache.object(forKey: url as AnyObject){
                //print("image loaded from cache")
                cell.image.image = cachedImage
            }

            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                //print("image downloaded from serve\(indexPath.row)")
                DispatchQueue.main.async {
                    cell.image.image = UIImage(data: data!)
                    if let images = UIImage(data: data!){
                    # To store the url in the cache
                    self.imageCache.setObject(images, forKey: url as AnyObject )
                        cell.cellSpinner.stopAnimating()
                        cell.cellSpinner.hidesWhenStopped = true
                    }
                }
            }
        }
```

# PopUp 
Created pop view to display the selected image. It's in a separate view controller  

## onPress Event 

#### didItemSelected  is working as onPress event 

```python 
 func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "PopupViewController"){
            navigationController?.pushViewController(vc, animated: true)
        }
        # URL is passed to popview controller 
        currentUrl = data?.imageData[indexPath.row].url
        indexAt = indexPath.row
        let segues = ["popup"]
               let segueID = segues[0]
               performSegue(withIdentifier: segueID, sender: self)
        
        print(indexPath.row)
    }
```
## onLoaded Event 
Image will load once the data is fetched from the api


```python 
# Called when 
    func onLoaded(image : UIImage , url : AnyObject, cell : CollectionViewCell) {
        self.imageCache.setObject(image, forKey: url as AnyObject )
            cell.cellSpinner.stopAnimating()
            cell.cellSpinner.hidesWhenStopped = true
    }
```

## Swipe image in PopUp

Popup is added with gesture. It can move previous  and next image by swiping left and right 

```python 
  let tap = UITapGestureRecognizer(target: self, action: #selector(close))
  grayView.addGestureRecognizer(tap)
 
  let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
  let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
              
  leftSwipe.direction = .left
  rightSwipe.direction = .right

  popupView.addGestureRecognizer(leftSwipe)
  popupView.addGestureRecognizer(rightSwipe)
```

