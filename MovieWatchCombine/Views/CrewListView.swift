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
                CrewListItemView(viewModel: viewModel, crew: crew)
                Divider()
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
    
    var body: some View {
        HStack(spacing: 16) {
//            Image(uiImage: viewModel.fecthImage(by: crew.profilePath) ?? UIImage())
            VStack(alignment: .leading) {
                Text(crew.name)
                Text(crew.department)
            }
            Spacer()
        }
    }
}

//struct CrewListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CrewListView(viewModel: <#MovieWatchViewModel#>)
//    }
//}
