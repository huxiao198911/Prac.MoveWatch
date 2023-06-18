//
//  MovieWatchApp.swift
//  MovieWatch
//
//  Created by Xiao Hu on 05/02/2023.
//

import SwiftUI

@main
struct MovieWatchApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MovieWatchView(movieViewModel: MovieWatchViewModel() )
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
