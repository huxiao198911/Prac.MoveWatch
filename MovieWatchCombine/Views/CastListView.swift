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
                CastListItemView(viewModel: viewModel, cast: cast)
                Divider()
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
    
    var body: some View {
        HStack(spacing: 16) {
//            Image(uiImage: viewModel.fecthImage(by: crew.profilePath) ?? UIImage())
            VStack(alignment: .leading) {
                Text(cast.original_name)
                Text(cast.character)
            }
            Spacer()
        }
    }
}

//struct CastListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CastListView()
//    }
//}
