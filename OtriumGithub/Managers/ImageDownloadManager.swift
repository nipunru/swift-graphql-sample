//
//  ImageDownloadManager.swift
//  OtriumGithub
//
//  Created by Nipun Ruwanpathirana on 2021-07-02.
//

import UIKit

class ImageDownloadManager {
    
    static let shared = ImageDownloadManager()
        
    func downloadImage(from url: URL, imageView: UIImageView, username: String) {
        if let cachedImage = CacheManager.shared.getCachedImage(username: username) {
            imageView.image = cachedImage
        } else {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                let image = UIImage(data: data) ?? UIImage(named: "placeholder")
                CacheManager.shared.setCachedImage(username: username, image: image!)
                DispatchQueue.main.async() {
                    imageView.image = image
                }
            }
        }
    }

    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
