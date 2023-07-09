//
//  MovieWatchViewModelTests.swift
//  MovieWatchViewModelTests
//
//  Created by Xiao Hu on 05/02/2023.
//

import XCTest
@testable import MovieWatch

class MockingURLSession: URLSession {
    
}

final class MovieWatchViewModelTests: XCTestCase {
    func testExample() throws {
        let mock = CodableUtils.decode(model: MovieList.self, jsonFile: "UpcomingMovieListMock")
        let viewModel = MovieWatchViewModel()
        
        
    }
}
