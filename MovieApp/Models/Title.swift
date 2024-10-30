//
//  Title.swift
//  MovieApp
//
//  Created by Şeyda Aydın on 30.10.2024.
//

import Foundation

struct TitleResponse: Codable {
    let results : [Title]
}

struct Title: Identifiable,Codable {
    
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    
}
