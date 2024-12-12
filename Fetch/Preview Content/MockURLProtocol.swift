//
//  MockURLProtocol.swift
//  FetchProject
//
//  Created by Nick Noble on 12/10/24.
//


import Foundation
import UIKit

/// This URL protocol can be used to make mock requests instead of live ones
class MockURLProtocol: URLProtocol {

    /// A mock NSURLSession to use for previews and unit tests
    static var session = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()

    /// Default response data based on URL. Can be overwritten for testing
    private static let defaultResponses: [String: Data?] = [
        "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json": PreviewData.jsonData("recipes"),
        "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json": PreviewData.jsonData("recipes-empty"),
        "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json": PreviewData.jsonData("recipes-malformed"),
    ]

    /// Response dictionary that can be modified for mocking purposes
    static var responses: [String: Data?] = defaultResponses
    
    /// Reset the responses and error to default values
    static func reset() {
        responses = defaultResponses
        error = nil
    }

    /// Saved requests that can be inspected for unit testing
    static var requests: [URLRequest] = []

    /// A mock error that will be thrown if not nil
    static var error: Error?

    override func startLoading() {
        // Save the request
        Self.requests.append(request)

        // Throw error if found
        if let error = Self.error {
            client?.urlProtocol(self, didFailWithError: error)
        }

        // Make sure URL is valid
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: NetworkError.invalidURL)
            return
        }

        var responseData: Data?
        // If fetching an image, load a sample image from the Preview assets
        if url.pathExtension == "jpg" {
            responseData = UIImage(named: "banana_pancakes")?.jpegData(compressionQuality: 1.0)
        } else {
            // Otherwise attempt to load a cached data response
            if let cached = Self.responses[url.absoluteString] {
                responseData = cached
            }
        }

        // Make sure mock data is available
        guard let responseData else {
            client?.urlProtocol(self, didFailWithError: NetworkError.invalidURL)
            return
        }

        // Return the successful response with data
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: responseData)
        client?.urlProtocolDidFinishLoading(self)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func stopLoading() {}
}

extension NetworkService {
    /// A convenience function to create a NetworkService configured for mocked responses
    static func mock(recipesUrl: URL = URLs.recipes) -> NetworkService {
        NetworkService(
            session: MockURLProtocol.session,
            dataCache: DataCache(
                fileManager: MockFileManager()
            ),
            recipesUrl: recipesUrl
        )
    }
}
