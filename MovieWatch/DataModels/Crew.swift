//
//  CrewListItem.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 05/02/2023.
//

import Foundation

struct Crew: Decodable, Hashable {
    let adult: Bool
    let gender: Int?
    let id: Int
    let known_for_department: String
    let name: String
    let original_name: String
    let popularity: Float
    let profile_path: String?
    let credit_id: String
    let department: String
    let job: String
}
