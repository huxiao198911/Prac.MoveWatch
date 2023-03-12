//
//  MovieCredit.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 19/02/2023.
//

import Foundation

struct MovieCredit: Decodable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
}
