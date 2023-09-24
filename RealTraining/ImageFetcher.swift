//
//  ImageFetcher.swift
//  RealTraining
//
//  Created by yc on 2023/09/24.
//

import UIKit

struct ImageFetcher {
    static func fetch(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            if let _ = error {
                completion(nil)
                return
            }
            
            if let data = data,
               let fetchedImage = UIImage(data: data) {
                
                completion(fetchedImage)
                return
            } else {
                completion(nil)
                return
            }
        }
        
        dataTask.resume()
    }
}
