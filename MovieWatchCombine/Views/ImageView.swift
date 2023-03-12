//
//  ImageView.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 19/02/2023.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var viewModel: MovieWatchViewModel
    let movie: Movie
    var movieImage: UIImage
    
    var body: some View {
        VStack {
                Image(uiImage: movieImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
        }
    }
}
//
//struct ImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageView()
//    }
//}
