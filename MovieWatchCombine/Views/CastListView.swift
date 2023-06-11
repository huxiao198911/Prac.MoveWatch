//
//  CastListView.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 05/02/2023.
//

import CachedAsyncImage
import SwiftUI

struct CastListView: View {
    @ObservedObject var viewModel: MovieWatchViewModel
    var movie: Movie
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.casts ?? [], id: \.self) { cast in
                        CastListItemView(
                            viewModel: viewModel,
                            cast: cast,
                            imagePath: viewModel.fetchImagePath(
                                posterPath: cast.profile_path,
                                backdropPath: nil
                            )
                        )
                        Divider()
                }
            }
        }
        .onAppear {
            Task {
                viewModel.casts = try await viewModel.fetchCredits(for: movie)?.cast
            }
        }
        .navigationTitle("Cast for the \(movie.title)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CastListItemView: View {
    var viewModel: MovieWatchViewModel
    var cast: Cast
    var imagePath: URL?
    
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
            
            VStack(alignment: .leading) {
                Text(cast.original_name)
                Text(cast.character)
            }
            Spacer()
        }
        .padding(16)
    }
}

//struct CastListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CastListView()
//    }
//}
