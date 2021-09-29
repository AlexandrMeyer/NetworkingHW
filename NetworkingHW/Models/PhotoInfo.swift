//
//  PhotoInfo.swift
//  NetworkingHW
//
//  Created by Александр on 25.09.21.
//

import Foundation

struct PhotoInfo: Codable {
    let title: String?
    let description: String?
    let copyright: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case copyright
        case url
    }
    
    init(photoInfo: [String: Any]) {
        title = photoInfo["title"] as? String
        description = photoInfo["explanation"] as? String
        copyright = photoInfo["copyright"] as? String
        url = photoInfo["url"] as? String
    }
}
