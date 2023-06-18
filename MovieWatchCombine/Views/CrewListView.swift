//
//  CrewListView.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 05/02/2023.
//

import CachedAsyncImage
import SwiftUI

struct CrewListView: View {
    @ObservedObject var viewModel: MovieWatchViewModel
    var movie: Movie
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.crews ?? [], id: \.self) { crew in
                    CrewListItemView(
                        viewModel: viewModel,
                        crew: crew,
                        imagePath: viewModel.fetchImagePath(
                            posterPath: crew.profile_path,
                            backdropPath: nil
                        )
                    )
                    Divider()
                }
            }
        }
        .onAppear {
            Task {
                viewModel.crews = try await viewModel.fetchCredits(for: movie)?.crew
            }
        }
        .navigationTitle("Crew for the \(movie.title)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CrewListItemView: View {
    var viewModel: MovieWatchViewModel
    var crew: Crew
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
                    // The image is loading
                    ProgressView()
                }
            }
            .frame(width: 100)
            
            VStack(alignment: .leading) {
                Text(crew.name)
                Text(crew.department)
            }
            Spacer()
        }
        .padding(16)
    }
}
