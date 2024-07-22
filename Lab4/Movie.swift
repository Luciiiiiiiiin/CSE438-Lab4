//
//  Movie.swift
//  Lab4
//
//  Created by Yuxuan Liu on 2024/7/22.
//

import Foundation

struct APIResults: Codable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let poster_path: String?
    let title: String
    let release_date: String?
    let vote_average: Double
    let overview: String
    let vote_count: Int
}
