//
//  MovieListItemView.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 12/02/2023.
//

import CachedAsyncImage
import SwiftUI

struct MovieListItemView: View {
    @ObservedObject var viewModel: MovieWatchViewModel
    var movie: Movie
    var imagePath: URL?
    var isFavorite: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
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
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .bold()
                    .lineLimit(1)
                Text(movie.release_date)
                
                HStack(spacing: 10) {
                    Text("🤩")
                    Text(String(format: "%.2f", movie.popularity))
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
