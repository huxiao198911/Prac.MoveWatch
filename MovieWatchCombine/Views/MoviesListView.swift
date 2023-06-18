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
                HStack {
                    Picker(selection: self.$movieViewModel.movieListType,
                           content: {
                        ForEach(MovieListType.allCases, id: \.self) { type in
                            Text(self.movieViewModel.getButtonLabel(by: type))
                        }
                    }, label: {
                        Text(self.movieViewModel.movieListType.rawValue)
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: self.movieViewModel.movieListType) { newValue in
                        self.movieViewModel.movieListType = newValue
                        self.movieViewModel.currentPage = 1
                        self.movieViewModel.movieList = []
                        Task {
                            try await movieViewModel.fetchMovieListFromURL(movieListType: self.movieViewModel.movieListType)
                        }
                    }
                }
                .padding()
                
                Divider()
                
                ScrollView {
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
                                    .onAppear {
                                        Task {
                                            if self.movieViewModel.movieIsLast(movie) {
                                                try await self.movieViewModel.loadMoreMovies(movieListType: self.movieViewModel.movieListType)
                                            }
                                        }
                                    }
                                }
                                Divider()
                            }
                        } else {
                            LazyVStack {
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
                .navigationTitle("\(self.movieViewModel.getButtonLabel(by: self.movieViewModel.movieListType)) Movies")
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
        }
        .onAppear {
            Task {
                try await movieViewModel.fetchMovieListFromURL(movieListType: self.movieViewModel.movieListType)
            }
        }
    }
}

struct MoviesListView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView(movieViewModel: MovieWatchViewModel())
    }
}
