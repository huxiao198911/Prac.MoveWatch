//
//  CodableUtils.swift
//  MovieWatchCombineTests
//
//  Created by Xiao Hu on 18/06/2023.
//

import Foundation

struct CodableUtils {
    /// This method will decode a given JSON file to a codable model
    /// - Parameters:
    ///   - model: the ``Codable`` model we want to decode the JSON to
    ///   - jsonFile: the JSON file we want to decode
    /// - Returns: a ``Codable`` object of type model or a fatal error
    static func decode<T: Decodable>(model: T.Type, jsonFile: String) -> T? {
        var tempData: Data?
        if let path = Bundle.allBundles.first(where: { $0.bundlePath.contains("xctest") })?.path(forResource: jsonFile, ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            tempData = data
        } else if let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"), let data = try? Data(contentsOf: url) {
            tempData = data
        }
        guard let data = tempData else {
            fatalError("Failed to parse \(jsonFile) to \(model.self) with bundle resources")
        }
        do {
            let testData = try JSONDecoder().decode(model, from: data)
            return testData
        } catch {
            fatalError("Failed to decode \(jsonFile).json to \(model.self) with error: \(error)")
        }
    }

    /// This method will encode given data and decode it back to a given model
    /// - Parameters:
    ///   - model: the ``Codable`` model we want to decode the data to
    ///   - mockedData: the ``Codable`` mockedData we want to encode and then decode to
    /// - Returns: a ``Codable`` object of type model or a fatal error
    static func encodeDecode<T: Codable, X: Codable>(model: T.Type, mockedData: X) -> T? {
        do {
            let encodedData = try JSONEncoder().encode(mockedData)
            let decodedData = try JSONDecoder().decode(model, from: encodedData)
            return decodedData
        } catch {
            fatalError("Failed to encode or decode data with error: \(error)")
        }
    }
}
