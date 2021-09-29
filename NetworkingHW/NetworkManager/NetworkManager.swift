//
//  NetworkManager.swift
//  NetworkingHW
//
//  Created by Александр on 25.09.21.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let apiNASA = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
    
    func fetchPotoInfoWithAlamofire(from url: String?, completion: @escaping (Result<PhotoInfo, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let jsonValue):
                    
                    guard let photoInfoData = jsonValue as? [String: Any] else {
                        completion(.failure(.noData))
                        return
                    }
                    let photoInfo = PhotoInfo(photoInfo: photoInfoData)
                    
                    DispatchQueue.main.async {
                        completion(.success(photoInfo))
                    }
                    
                case .failure(_):
                    completion(.failure(.decodingError))
                }
            }
    }

    private init() {}
}
