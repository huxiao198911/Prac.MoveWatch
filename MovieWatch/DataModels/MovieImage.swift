//
//  MovieImage.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 19/02/2023.
//

import Foundation

struct MovieImage {
    let id: Int
    let backdrops: [Poster]
    let poster: [Poster]
}

struct Poster {
    let aspect_ratio: Float
    let file_path: String
    let height: Int
    let vote_average: Int
    let vote_count: Int
    let width: Int
}
