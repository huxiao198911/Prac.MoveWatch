//
//  MoviesListView.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 05/02/2023.
//

import SwiftUI

struct MoviesListView: View {
    @ObservedObject var movieViewModel: MovieWatchViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                
                ScrollView{
                    ForEach(movieViewModel.movieList ?? [], id: \.self) { movie in
                        if let imagepath = movieViewModel.fetchImagePath(from: movie) {
                            NavigationLink {
                                MovieDetailsView(movieViewModel: movieViewModel, movie: movie)
                            } label: {
                                MovieListItemView(
                                    viewModel: movieViewModel,
                                    movie: movie,
                                    movieImage: movieViewModel.images.first(where: { $0.key == imagepath })?.value ?? UIImage(),
                                    isFavorite: movieViewModel.favoriteMovies.contains(movie)
                                )
                            }
                            Divider()
                        }
                    }
                }
            }
            .navigationBarTitle("Popular Movies", displayMode: .inline)
        }
        .onAppear {
            Task {
                movieViewModel.movieList = try await movieViewModel.fetchMovieListFromURL(page: 1, movieListType: "popular")?.results
                movieViewModel.images = try await movieViewModel.loadImages(from: movieViewModel.fetchImagePaths(from: movieViewModel.movieList ?? []))
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
