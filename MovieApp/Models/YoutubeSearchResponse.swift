//
//  YoutubeSearchResponse.swift
//  MovieApp
//
//  Created by Şeyda Aydın on 30.10.2024.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: VideoElementId
}

struct VideoElementId: Codable {
    let kind: String
    let videoId: String
}
