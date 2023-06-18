//
//  MovieWatchView.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 05/02/2023.
//

import SwiftUI

struct MovieWatchView: View {
    @StateObject var movieViewModel = MovieWatchViewModel()
    @State var isPopularMoviesShown = true
    @State var isFavoriteMoviesShown = false
    
    var body: some View {
        VStack {
            TabView {
                MoviesListView(movieViewModel: movieViewModel)
                    .tabItem {
                        Label("\(self.movieViewModel.getButtonLabel(by: self.movieViewModel.movieListType)) movies", systemImage: "film")
                    }
                FavoriteMoviesListView(movieViewModel: movieViewModel)
                    .tabItem {
                        Label("Favorite movies", systemImage: "star")
                    }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MovieWatchView_Previews: PreviewProvider {
    static var previews: some View {
        MovieWatchView()
    }
}
