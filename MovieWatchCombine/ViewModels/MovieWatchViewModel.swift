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
    
    func loadImage(by imagePath: URL) async throws -> UIImage? {
            if let imageData = try? Data(contentsOf: imagePath) {
            return UIImage(data: imageData)
        } else {
            return nil
        }
    }
    
   
    
    func addFavorite(movie: Movie) {
        favoriteMovies.append(movie)
    }

    func removeFavorite(movie: Movie) {
        if let index = favoriteMovies.firstIndex(of: movie) {
            favoriteMovies.remove(at: index)
        }
    }
    
//    func loadImages(from urls: [URL]) async throws -> [URL: UIImage?] {
//        try await withThrowingTaskGroup(of: (URL, UIImage?).self) { group in
//            for url in urls {
//                group.addTask{
//                    let image = try await self.loadImage(by: url)
//                    return (url, image)
//                }
//            }
//            
//            var images = [URL: UIImage]()
//            
//            for try await (url, image) in group {
//                images[url] = image
//            }
//            
//            return images
//        }
//    }
    
//    func fetchImagePaths(from movies: [Movie]) async throws -> [URL] {
//        var paths: [String] = []
//        movies.forEach { movie in
//            var path: String = ""
//            if movie.poster_path != nil {
//                path = "https://image.tmdb.org/t/p/original/\(String(describing: movie.poster_path ?? ""))"
//            } else {
//                path = "https://image.tmdb.org/t/p/original/\(String(describing: movie.backdrop_path ?? ""))"
//            }
//            paths.append(path)
//        }
//        return paths.compactMap { URL(string: $0) }
//    }
//
//    func fetchImagePaths(from crews: [Crew]) async throws -> [URL] {
//        var paths: [String] = []
//        crews.forEach { crew in
//            var path: String = ""
//            if crew.profile_path != nil {
//                path = "https://image.tmdb.org/t/p/original/\(String(describing: crew.profile_path ?? ""))"
//            } else {
//                path = "https://image.tmdb.org/t/p/original/\(String(describing: crew.profile_path ?? ""))"
//            }
//            paths.append(path)
//        }
//        return paths.compactMap { URL(string: $0) }
//    }
//
//    func fetchImagePaths(from casts: [Cast]) async throws -> [URL] {
//        var paths: [String] = []
//        casts.forEach { cast in
//            var path: String = ""
//            if cast.profile_path != nil {
//                path = "https://image.tmdb.org/t/p/original/\(String(describing: cast.profile_path ?? ""))"
//            } else {
//                path = "https://image.tmdb.org/t/p/original/\(String(describing: cast.profile_path ?? ""))"
//            }
//            paths.append(path)
//        }
//        return paths.compactMap { URL(string: $0) }
//    }
//
//    func fetchMoviesFromURL(_ completion: @escaping (Result<[Movie], Error>) -> Void) {
//        if let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=en-US") {
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                guard error == nil else {
//                    completion(.failure(error!))
//                    return
//                }
//
//                guard let data = data else {
//                    print("No data")
//                    return
//                }
//
//                do {
//                    let decoder = JSONDecoder()
//                    let movies = try decoder.decode([Movie].self, from: data)
//                    completion(.success(movies))
//                } catch {
//                    completion(.failure(error))
//                }
//            }
//            .resume()
//        }
//    }
    
//    func fetchMoviesFromURL(page: Int = 1) async throws -> [Movie]? {
//        if let url = URL(string: "https://api.themoviedb.org/4/list/1?page=1&api_key=\(apiKey)") {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let decoder = JSONDecoder()
//            let movies = try decoder.decode([Movie].self, from: data)
//            return movies
//        } else {
//            return nil
//        }
//    }
//
//    func fetchMovies() -> [Movie]? {
//        do {
//            let decoder = JSONDecoder()
//            if let movieMock = Bundle.main.path(forResource: "MovieMock", ofType: "json"),
//               let data = try? Data(contentsOf: URL(fileURLWithPath: movieMock)) {
//                let moviesList = try decoder.decode([Movie].self, from: data)
//                return moviesList
//            } else {
//                return nil
//            }
//        } catch {
//            print(error)
//            return nil
//        }
//    }
//
//    func fetchCrewForMovie() -> [Crew]? {
//        do {
//            let decoder = JSONDecoder()
//            if let crewMock = Bundle.main.path(forResource: "CrewMock", ofType: "json"),
//               let data = try? Data(contentsOf: URL(fileURLWithPath: crewMock)) {
//                let response = try decoder.decode([Crew].self, from: data)
//                return response
//            } else {
//                return nil
//            }
//        } catch {
//            print(error)
//            return nil
//        }
//    }
//
//    func fetchCastForMovie() -> [Cast]? {
//        do {
//            if let castMock = Bundle.main.path(forResource: "CastMock", ofType: "json"),
//               let data = try? Data(contentsOf: URL(fileURLWithPath: castMock)) {
//                let response = try JSONDecoder().decode([Cast].self, from: data)
//                return response
//            } else {
//                return nil
//            }
//        } catch {
//            print(error)
//            return nil
//        }
//    }

    
}
