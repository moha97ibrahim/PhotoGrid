//
//  ImageManager.swift
//  PhotoGrid
//
//  Created by Mohammed Ibrahim on 15/8/21.
//

import Foundation
import UIKit

// MARK:-  Protocol for Image Data Update
protocol ImageDataDelegate {
    func didUpdateImageData(data : ImageDatatoKV)
}

class ImageManager {
    
    // MARK: Properties
    var imageDelegate : ImageDataDelegate?
    
    // MARK: Variables
    var imageCache = NSCache<AnyObject, AnyObject>()
    
    // MARK:-  Fetch Image Data
    func fetchData(){
        let url = NSURL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&count=42")
        let imageData = NSMutableURLRequest(url: url! as URL,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        Request(request: imageData)
        
    }
    
    func Request(request : NSMutableURLRequest){
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, responce , error) -> Void in
            if error != nil {
                print(error.debugDescription)
                return
            }
            else{
                let httpResponce = responce as! HTTPURLResponse
                print(httpResponce)
            }

            if let safeData = data {
                if let convetedJSON = self.JSONParse(data: safeData){
                    print(convetedJSON.imageData[0].url)
                    self.imageDelegate?.didUpdateImageData(data: convetedJSON)
                }
            }
        })
        dataTask.resume()
    }
    
    
    // MARK:-  JSON Parser
    func JSONParse (data : Data) -> ImageDatatoKV? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(ImageDatatoKV.self, from: data)
            return decodedData
        }
        catch{
            print(error)
            return nil
        }
    }
    


}
