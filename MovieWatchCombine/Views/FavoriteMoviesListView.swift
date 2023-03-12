//
//  FavoriteMoviesListView.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 05/02/2023.
//

import SwiftUI

struct FavoriteMoviesListView: View {
    @ObservedObject var movieViewModel: MovieWatchViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                
                ScrollView {
                    ForEach(movieViewModel.favoriteMovies, id: \.self) { movie in
                        NavigationLink {
                            MovieDetailsView(movieViewModel: movieViewModel, movie: movie)
                        } label: {
                            MovieListItemView(
                                viewModel: movieViewModel,
                                movie: movie,
                                imagePath: movieViewModel.fetchImagePath(from: movie),
                                isFavorite: movieViewModel.favoriteMovies.contains(movie)
                            )
                        }
                        Divider()
                    }
                }
            }
            .navigationBarTitle("Favorite Movies", displayMode: .inline)
        }
    }
}

//struct FavoriteMoviesListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteMoviesListView()
//    }
//}
