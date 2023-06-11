//
//  MovieList.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 19/02/2023.
//

import Foundation

struct MovieList: Decodable {
    let page: Int
    let results: [Movie]
    let total_results: Int
    let total_pages: Int
}

struct Movie: Codable, Hashable, Identifiable {
    let poster_path: String?
    let adult: Bool
    let overview: String
    let release_date: String
    let original_title: String
    let genre_ids: Array<Int>
    let id: Int
    let original_language: String
    let title: String
    let backdrop_path: String?
    let popularity: Float
    let vote_count: Int
    let vote_average: Float
}
