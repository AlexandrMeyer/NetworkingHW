//
//  PhotoInfo.swift
//  NetworkingHW
//
//  Created by Александр on 25.09.21.
//

import Foundation

struct PhotoInfo: Decodable {
    let title: String?
    let explanation: String?
    let copyright: String?
    let url: String?
}
