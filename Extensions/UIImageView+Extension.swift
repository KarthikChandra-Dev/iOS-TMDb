//
//  UIImageView+Extension.swift
//  iOS-TMDb
//
//  Created by Karthik Chandra Amudha on 9/19/21.
//

import UIKit

extension UIImageView {
    
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        if let cachedImage = Cache.shared.image(for: url.absoluteString) {
            self.image = cachedImage
        } else {
            downloadImage(url: url, placeholder: placeholder)
        }
    }
    
    private func downloadImage(url: URL, placeholder: UIImage?) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    Cache.shared.add(downloadedImage, for: url.absoluteString)
                    self.image = downloadedImage
                }
            } else {
                DispatchQueue.main.async {
                    self.image = placeholder
                }
            }
        }.resume()
    }
}
