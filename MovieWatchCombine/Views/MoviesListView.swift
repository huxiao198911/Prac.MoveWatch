//
//  MoviesListView.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 05/02/2023.
//

import SwiftUI

struct MoviesListView: View {
    @ObservedObject var movieViewModel: MovieWatchViewModel
    @State private var searchText = ""
    
    private func filterMovies(movies: [Movie]) -> [Movie] {
        movies.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                
                ScrollView{
                    LazyVStack {
                        if self.searchText.isEmpty {
                            ForEach(movieViewModel.movieList ?? [], id: \.self) { movie in
                                NavigationLink {
                                    MovieDetailsView(movieViewModel: movieViewModel, movie: movie)
                                } label: {
                                    MovieListItemView(
                                        viewModel: movieViewModel,
                                        movie: movie,
                                        imagePath: movieViewModel.fetchImagePath(
                                            posterPath: movie.poster_path,
                                            backdropPath: movie.backdrop_path
                                        ),
                                        isFavorite: movieViewModel.favoriteMovies.contains(movie)
                                    )
                                }
                                Divider()
                            }
                        } else {
                            ForEach(self.filterMovies(movies: movieViewModel.movieList ?? []), id: \.self) { movie in
                                NavigationLink {
                                    MovieDetailsView(movieViewModel: movieViewModel, movie: movie)
                                } label: {
                                    MovieListItemView(
                                        viewModel: movieViewModel,
                                        movie: movie,
                                        imagePath: movieViewModel.fetchImagePath(
                                            posterPath: movie.poster_path,
                                            backdropPath: movie.backdrop_path
                                        ),
                                        isFavorite: movieViewModel.favoriteMovies.contains(movie)
                                    )
                                }
                                Divider()
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Popular Movies", displayMode: .inline)
        }
        .searchable(text: $searchText)
        .onAppear {
            Task {
                try await movieViewModel.loadMoreMovies(movieListType: "popular")
            }
        }
    }
}
//
//struct MoviesListView_Previews: PreviewProvider {
//    static var previews: some View {
//        MoviesListView()
//    }
//}
