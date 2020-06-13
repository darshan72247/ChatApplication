//
//  Extension.swift
//  ChatApplication
//
//  Created by Yash Patel on 2020-06-13.
//  Copyright © 2020 Darshan Patel. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView{
    func loadImageUsingCacheWithUrlString(urlString : String){
        
        self.image = nil
        
        //check cache for image first
        if let cacheImage = imageCache.object(forKey: urlString as NSString) as? UIImage{
            self.image = cacheImage
            return
        }
        
        //otherwise download the image form firestore
        if let url = URL(string: urlString){
                       URLSession.shared.dataTask(with: url) { (data, response, error) in
                           if error != nil {
                               print(error!)
                               return
                           } else {
                               guard let data = data else { return }
                               DispatchQueue.main.async {
                                   if let downloadedImage = UIImage(data: data){
                                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                                       self.image = downloadedImage
                                       //cell.imageView?.image = downloadedImage
                                   }
                               }
                           }
                       }.resume()
                   }
    }
}
