//
//  MovieDetailsView.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 05/02/2023.
//

import CachedAsyncImage
import SwiftUI

struct MovieDetailsView: View {
    @ObservedObject var movieViewModel: MovieWatchViewModel
    var movie: Movie
//    @State private var movieImage: UIImage? = nil
    @State private var imagePath: URL? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedAsyncImage(url: imagePath, urlCache: .imageCache) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else if phase.error != nil {
                        Text("failed to load image")
                            .foregroundColor(Color.red)
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 100)
                
                Button {
                    movieViewModel.favoriteMovies.contains(movie) ? movieViewModel.removeFavorite(movie: movie) : movieViewModel.addFavorite(movie: movie)
                } label: {
                    Text(!movieViewModel.isFavoriteMovie(movie: movie) ? "☆ Add to favorites" : "★ Remove favorite")
                }
                                
                VStack {
                    NavigationLink("Show crew >") {
                        CrewListView(viewModel: movieViewModel, movie: movie)
                    }
                    
                    NavigationLink("Show cast >") {
                        CastListView(viewModel: movieViewModel, movie: movie)
                    }
                }
                
                Text(movie.title)
                    .bold()
                    .font(.title)
                
                Text("🗓️ release: \(movie.release_date)")
                    .bold()
                Text("🤩 popularity: \(String(describing: movie.popularity))")
                    .bold()
                Text("🎟️ rating: \(String(describing: movie.vote_average)) (\(String(describing: movie.vote_count)) votes)")
                    .bold()
                
                Spacer()
                
                Text(movie.overview)
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .padding(16)
        .onAppear {
            Task {
                imagePath = movieViewModel.fetchImagePath(
                    posterPath: movie.poster_path,
                    backdropPath: movie.backdrop_path
                )
            }
        }
    }
}

//struct MovieDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieDetailsView()
//    }
//}
