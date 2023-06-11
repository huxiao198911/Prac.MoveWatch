//
//  MovieWatchViewModel.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 05/02/2023.
//

import Foundation
import SwiftUI

enum MovieListType: String {
    case now_playing
    case popular
    case top_rated
    case upcoming
}

class MovieWatchViewModel: ObservableObject {
    let baseURL = "https://api.themoviedb.org/3/movie/"
    let language = "en-US"
    private let apiKey = Configuration.apiKey
    
    @Published var favoriteMovies: [Movie] = []
    @Published var movieList: [Movie]? = []
    @Published var casts: [Cast]? = []
    @Published var crews: [Crew]? = []
    @Published var currentPage: Int = 1
    @Published var movieListType: MovieListType = .popular
    
    func isFavoriteMovie(movie: Movie) -> Bool {
        return self.favoriteMovies.contains(where: { $0.id == movie.id }) ? true : false
    }
    
    @MainActor
    func loadMoreMovies() async throws {
        try await self.fetchMovieListFromURL(movieListType: self.movieListType)
    }
    
    @MainActor
    func fetchMovieListFromURL(movieListType: MovieListType) async throws {
        let apiURLString =  "\(baseURL)\(movieListType.rawValue)?api_key=\(apiKey)&language=\(language)&page=\(self.currentPage)"
        guard let url = URL(string: apiURLString) else {
            return
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let movies = try decoder.decode(MovieList.self, from: data)
        for movie in movies.results {
            self.movieList?.append(movie)
        }
        self.currentPage += 1
    }
    
    func fetchCredits(for movie: Movie) async throws -> MovieCredit? {
        let apiURLString = "\(baseURL)\(movie.id)/credits?api_key=\(apiKey)&language=\(language)"
        guard let url = URL(string: apiURLString) else {
            return nil
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let movieCredit = try decoder.decode(MovieCredit.self, from: data)
        return movieCredit
    }
    
    func fetchImagePath(posterPath: String?, backdropPath: String?) -> URL? {
        var path: String = ""
        if let posterPath {
            path = "https://image.tmdb.org/t/p/original/\(String(describing: posterPath))"
        } else if let backdropPath{
            path = "https://image.tmdb.org/t/p/original/\(String(describing: backdropPath))"
        } else {
            path = ""
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
    
    func movieIsLast(_ movie: Movie) -> Bool {
        guard let lastMovie = self.movieList?.last else {
            return false
        }
        return movie.id == lastMovie.id
    }
}
