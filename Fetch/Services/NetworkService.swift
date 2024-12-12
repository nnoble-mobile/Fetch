//
//  NetworkService.swift
//  FetchProject
//
//  Created by Nick Noble on 12/10/24.
//

import Foundation

/// Anticipated network errors
enum NetworkError: Error {
    case invalidURL
    case decodingError
}

/// A network service that uses URLSession to fetch recipes and images.
/// The session, cache, and recipesUrl are all injected
class NetworkService {
    private let session: URLSession
    private let dataCache: DataCache
    private let recipesUrl: URL
    private let decoder = JSONDecoder()

    init(
        session: URLSession = .shared,
        dataCache: DataCache = DataCache(),
        recipesUrl: URL = URLs.recipes
    ) {
        self.session = session
        self.dataCache = dataCache
        self.recipesUrl = recipesUrl
    }
}

extension NetworkService {
    
    /// Fetches recipes using the injected URL.
    /// - Returns: Array of recipes (can be empty)
    func fetchRecipes() async throws -> [Recipe] {
        do {
            let (data, _) = try await session.data(from: recipesUrl)
            let response = try decoder.decode(RecipeResponse.self, from: data)
            return response.recipes
        } catch let error as DecodingError {
            Logger.network.error("Decoding error: \(error)")
            throw NetworkError.decodingError
        } catch {
            throw error
        }
    }

    
    /// Fetches an image using the given URL. The response is cached using the injected `DataCache`
    /// - Parameter url: the image URL to fetch
    /// - Returns: the `Data` fetched from the URL
    func fetchImage(from url: URL) async throws -> Data {
        // Check cache first
        if let cachedImage = dataCache.get(url) {
            Logger.network.info("Image fetched from cache: \(url.absoluteString)")
            return cachedImage
        }
        let (data, _) = try await session.data(from: url)
        Logger.network.info("Image fetched from network, caching it: \(url.absoluteString)")
        dataCache.set(data, for: url)
        return data
    }
}
