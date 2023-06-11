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
    var totalPages = 0
    var page: Int = 1
    
    
    func isFavoriteMovie(movie: Movie) -> Bool {
        return self.favoriteMovies.contains(where: { $0.id == movie.id }) ? true : false
    }
    
    @MainActor
    func loadMoreMovies(movieListType: String) async throws {
        let currentMovieList = try await self.fetchMovieListFromURL(movieListType: movieListType)
        let thresholdIndex = self.movieList?.index(self.movieList?.endIndex ?? -1, offsetBy: -1)
        if thresholdIndex == (self.movieList?.count ?? -1) - 1, (page + 1) <= currentMovieList?.total_pages ?? -1 {
            page += 1
            try await self.loadMovies(movieListType: movieListType)
        }
    }
    
    @MainActor
    func loadMovies(movieListType: String) async throws {
        let currentMovieList = try await self.fetchMovieListFromURL(movieListType: movieListType)
        self.movieList = currentMovieList?.results
        self.totalPages = currentMovieList?.total_pages ?? -1
    }
    
    func fetchMovieListFromURL(movieListType: String) async throws -> MovieList? {
        let apiURLString =  "\(baseURL)\(movieListType)?api_key=\(apiKey)&language=\(language)&page=\(page)"
        guard let url = URL(string: apiURLString) else {
            return nil
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let movies = try decoder.decode(MovieList.self, from: data)
        return movies
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
}
