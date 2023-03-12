//
//  MovieWatchViewModel.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 05/02/2023.
//

import Foundation
import SwiftUI

class MovieWatchViewModel: ObservableObject {
    let baseURL = "https://api.themoviedb.org/3/movie/"
    let language = "en-US"
    private let apiKey = Configuration.apiKey
    
    @Published var favoriteMovies: [Movie] = []
    @Published var movieList: [Movie]? = []
    @Published var casts: [Cast]? = []
    @Published var crews: [Crew]? = []
    
    
    func isFavoriteMovie(movie: Movie) -> Bool {
        return self.favoriteMovies.contains(where: { $0.id == movie.id }) ? true : false
    }
    
    func fetchMovieListFromURL(page: Int, movieListType: String) async throws -> MovieList? {
        let apiURLString =  "\(baseURL)\(movieListType)?api_key=\(apiKey)&language=\(language)&page=\(page)"
        if let url = URL(string: apiURLString) {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let movies = try decoder.decode(MovieList.self, from: data)
            return movies
        } else {
            return nil
        }
    }
    
    func fetchCredits(for movie: Movie) async throws -> MovieCredit? {
        let apiURLString = "\(baseURL)\(movie.id)/credits?api_key=\(apiKey)&language=\(language)"
        if let url = URL(string: apiURLString) {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let movieCredit = try decoder.decode(MovieCredit.self, from: data)
            return movieCredit
        } else {
            return nil
        }
    }
    
    func fetchImagePath(from movie: Movie) -> URL? {
        var path: String = ""
        if movie.poster_path != nil {
            path = "https://image.tmdb.org/t/p/original/\(String(describing: movie.poster_path ?? ""))"
        } else {
            path = "https://image.tmdb.org/t/p/original/\(String(describing: movie.backdrop_path ?? ""))"
        }
        let url = URL(string: path)
        return url
    }
    
    func fetchImagePath(from crew: Crew) -> URL? {
        var path: String = ""
        if crew.profile_path != nil {
            path = "https://image.tmdb.org/t/p/original/\(String(describing: crew.profile_path ?? ""))"
        } else {
            path = "https://image.tmdb.org/t/p/original/\(String(describing: crew.profile_path ?? ""))"
        }
        let url = URL(string: path)
        return url
    }
    
    func fetchImagePath(from cast: Cast) -> URL? {
        var path: String = ""
        if cast.profile_path != nil {
            path = "https://image.tmdb.org/t/p/original/\(String(describing: cast.profile_path ?? ""))"
        } else {
            path = "https://image.tmdb.org/t/p/original/\(String(describing: cast.profile_path ?? ""))"
        }
        let url = URL(string: path)
        return url
    }
    
    func addFavorite(movie: Movie) {
        favoriteMovies.append(movie)
    }

    func removeFavorite(movie: Movie) {
        if let index = favoriteMovies.firstIndex(of: movie) {
            favoriteMovies.remove(at: index)
        }
    }
}
