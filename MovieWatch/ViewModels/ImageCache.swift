//
//  ImageCache.swift
//  MovieWatchCombine
//
//  Created by Xiao Hu on 12/03/2023.
//

import Foundation

extension URLCache {
   static let imageCache = URLCache(memoryCapacity: 512*1000, diskCapacity: 10*1000*1000)
}
