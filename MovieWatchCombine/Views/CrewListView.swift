//
//  CrewListView.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 05/02/2023.
//

import SwiftUI

struct CrewListView: View {
    @ObservedObject var viewModel: MovieWatchViewModel
    var movie: Movie
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.crews ?? [], id: \.self) { crew in
                if let imagepath = viewModel.fetchImagePath(from: crew) {
                    CrewListItemView(
                        viewModel: viewModel,
                        crew: crew,
                        memberImage: viewModel.images.first(where: { $0.key == imagepath })?.value ?? UIImage()
                    )
                    Divider()
                }
                
            }
        }
        .onAppear {
            Task {
                viewModel.crews = try await viewModel.fetchCredits(for: movie)?.crew
                viewModel.images = try await viewModel.loadImages(from: viewModel.fetchImagePaths(from: viewModel.crews ?? []))
            }
        }
        .navigationTitle("Crew for the \(movie.title)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CrewListItemView: View {
    var viewModel: MovieWatchViewModel
    var crew: Crew
    var memberImage: UIImage
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ImageView(viewModel: viewModel, movieImage: memberImage)
            
            VStack(alignment: .leading) {
                Text(crew.name)
                Text(crew.department)
            }
            Spacer()
        }
        .padding(16)
    }
}

//struct CrewListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CrewListView(viewModel: <#MovieWatchViewModel#>)
//    }
//}
