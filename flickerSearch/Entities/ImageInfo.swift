//
//  ImageInfo.swift
//  flickerSearch
//
//  Created by Mian on 9/23/24.
//

import Foundation

struct ImageInfo: Codable, Hashable{
    let title: String?
    let media: Media?
    let description: String?
    let author: String?
    let publishedDate: String?
    enum CodingKeys: String, CodingKey {
        case title
        case media
        case description
        case author
        case publishedDate = "published"
    }
}

struct Media: Codable, Hashable{
    let imagePath: String?
    enum CodingKeys: String, CodingKey {
        case imagePath = "m"
    }
}

struct ImageResponse: Codable{
    let items: [ImageInfo]?
}
