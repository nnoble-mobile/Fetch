//
//  DataCache.swift
//  FetchProject
//
//  Created by Nick Noble on 12/10/24.
//

import Foundation
import CryptoKit

/// A custom cache for data fetched from URLs
class DataCache {
    private let fileManager: FileManager
    private let cacheDirectory: URL

    // Use dependency injection for the FileManager
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.cacheDirectory = documentsDirectory.appendingPathComponent("DataCache")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    /// Return the cached data if its available
    /// - Parameter url: The URL is hashed before used as a key for the cached data
    /// - Returns: Cached Data (if available)
    func get(_ url: URL) -> Data? {
        let urlHash = hash(for: url)
        let fileURL = cacheDirectory.appendingPathComponent(urlHash)
        let x = fileManager.contents(atPath: fileURL.path())
        return x
    }
    
    /// Caches the data provided by its hashed URL
    /// - Parameters:
    ///   - data: The Data to cache
    ///   - url: The URL is hashed before used as a key for the cached data
    func set(_ data: Data, for url: URL) {
        let urlHash = hash(for: url)
        let fileURL = cacheDirectory.appendingPathComponent(urlHash)
        fileManager.createFile(atPath: fileURL.path(), contents: data)
    }

    /// Hash the URL so the URL components don't interfere with the file path
    /// - Parameter url: the URL to hash
    /// - Returns: the hashed URL, safe to use in a file path
    private func hash(for url: URL) -> String {
        // This default value is just to satisfy the compiler, converting a url's absoluteString to
        // utf8 data will always succeed
        let hashData = url.absoluteString.data(using: .utf8) ?? Data()
        let hash = SHA256.hash(data: hashData)
        return hash.description
    }
}

