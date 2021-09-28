//
//  NetworkManager.swift
//  NetworkingHW
//
//  Created by Александр on 25.09.21.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchPotoInfo(completion: @escaping (Result<PhotoInfo, NetworkError>) -> Void) {
        let urlComponent = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
        
        guard let url = URL(string: urlComponent) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
                do {
                    let photoInfo = try JSONDecoder().decode(PhotoInfo.self, from: data)
                    completion(.success(photoInfo))
                } catch {
                    completion(.failure(.decodingError))
                }
            
            }.resume()
        }
    
    
    func fetchImage(from url: String?, complition: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            complition(.failure(.invalidURL))
            return
        }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                complition(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                complition(.success(imageData))
            }
        }
    }
    
    private init() {}
}
