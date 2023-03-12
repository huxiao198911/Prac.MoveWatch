//
//  MovieListItemView.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 12/02/2023.
//

import SwiftUI

struct MovieListItemView: View {
    @ObservedObject var viewModel: MovieWatchViewModel
    var movie: Movie
    var movieImage: UIImage
    var isFavorite: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ImageView(viewModel: viewModel, movieImage: movieImage)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .bold()
                    .lineLimit(1)
                Text(movie.release_date)
                
                HStack(spacing: 10) {
                    Text("🤩")
                    Text(String(describing: movie.popularity))
                    Text("🎟️")
                    Text(String(describing: movie.vote_average))
                }
            }
            Spacer()
            
            Text(isFavorite ? "★" : "☆")
        }
        .padding(16)
    }
}
//
//struct MovieListItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieListItemView()
//    }
//}
