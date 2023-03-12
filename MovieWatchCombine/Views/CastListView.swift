//
//  CastListView.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 05/02/2023.
//

import SwiftUI

struct CastListView: View {
    @ObservedObject var viewModel: MovieWatchViewModel
    var movie: Movie
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.casts ?? [], id: \.self) { cast in
                if let imagepath = viewModel.fetchImagePath(from: cast) {
                    CastListItemView(
                        viewModel: viewModel,
                        cast: cast,
                        memberImage: viewModel.images.first(where: { $0.key == imagepath })?.value ?? UIImage()
                    )
                    Divider()
                }
            }
        }
        .onAppear {
            Task {
                viewModel.casts = try await viewModel.fetchCredits(for: movie)?.cast
                viewModel.images = try await viewModel.loadImages(from: viewModel.fetchImagePaths(from: viewModel.casts ?? []))
            }
        }
        .navigationTitle("Cast for the \(movie.title)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CastListItemView: View {
    var viewModel: MovieWatchViewModel
    var cast: Cast
    var memberImage: UIImage
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ImageView(viewModel: viewModel, movieImage: memberImage)
            
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
