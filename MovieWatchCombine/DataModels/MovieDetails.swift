//
//  MovieDetails.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 05/02/2023.
//

import Foundation

//struct Movie: Decodable, Hashable {
//    let id: Int
//    let posterPath: String
//    let backdropPath: String
//    let title: String
//    let releaseDate: String
//    let popularity: Float
//    let voteAverage: Float
//    let voteCount: Int
//    let overview: String
//}

struct MovieDetails {
    let api_key: String
    let movie_id: Int
    let backdrop_path: String?
    let language: String?
    let adult: Bool?
    let genres: [Genres]
    let id: Int
    let imdb_id: String?
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Float
    let poster_path: String?
    let production_companies: [ProductCompany]
    let release_date: String
    let status: String
    let title: String
    let vote_average: Float
    let vote_count: Int
}

struct Genres {
    let id: Int
    let name: String
}

struct ProductCompany {
    let name: String
    let id: Int
    let logo_path: String?
    let origin_country: String
}
