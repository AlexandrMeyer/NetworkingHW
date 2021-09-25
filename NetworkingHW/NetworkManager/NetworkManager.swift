//
//  NetworkManager.swift
//  NetworkingHW
//
//  Created by Александр on 25.09.21.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchPotoInfo(completion: @escaping (Result<PhotoInfo, Error>) -> Void) {
        let urlComponent = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
        
        guard let url = URL(string: urlComponent) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                
                do {
                    let photoInfo = try JSONDecoder().decode(PhotoInfo.self, from: data)
                    completion(.success(photoInfo))
                } catch let error {
                    completion(.failure(error))
                }
                
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(error!))
            }
        }.resume()
    }
    
    private init() {}
}
