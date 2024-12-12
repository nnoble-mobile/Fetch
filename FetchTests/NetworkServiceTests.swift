//
//  FetchProjectTests.swift
//  FetchProjectTests
//
//  Created by Nick Noble on 12/10/24.
//

import XCTest
@testable import Fetch

class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    var mockFileManager: MockFileManager!
    let imageURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/123/small.jpg")!

    override func setUp() {
        super.setUp()
        mockFileManager = MockFileManager()
        networkService = NetworkService(
            session: MockURLProtocol.session,
            dataCache: DataCache(fileManager: mockFileManager)
        )
        MockURLProtocol.requests = []
    }

    override func tearDown() {
        super.tearDown()
        networkService = nil
        mockFileManager = nil
        MockURLProtocol.reset()
    }

    func testSuccessfulRecipeFetching() async throws {
        MockURLProtocol.responses[URLs.recipes.absoluteString] =
        """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                },
            ]
        }
        """.data(using: .utf8)

        // Fetch recipes
        let recipes = try await networkService.fetchRecipes()

        // Assert
        XCTAssertFalse(recipes.isEmpty)
        XCTAssertEqual(recipes.count, 1)
    }

    func testEmptyRecipesFetching() async throws {
        MockURLProtocol.responses[URLs.recipes.absoluteString] =
        """
        {
            "recipes": []
        }
        """.data(using: .utf8)

        let recipes = try await networkService.fetchRecipes()
        XCTAssertTrue(recipes.isEmpty)
    }

    func testNetworkErrorHandling() async {
        MockURLProtocol.error = UnknownError.unknown

        do {
            _ = try await networkService.fetchRecipes()
            XCTFail("Should throw a network error")
        } catch {
            XCTAssertTrue(true)
        }
    }

    func testMalformedDataHandling() async {
        MockURLProtocol.responses[URLs.recipes.absoluteString] =
        """
        {
            "cuisine": "British",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
            "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
            "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
            "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
        },
        """.data(using: .utf8)

        do {
            _ = try await networkService.fetchRecipes()
            XCTFail("Should throw a decoding error")
        } catch let error as NetworkError {
            switch error {
            case .decodingError:
                XCTAssertTrue(true)
            default:
                XCTFail("Unexpected error type")
            }
        } catch {
            XCTFail("Unexpected error type")
        }
    }

    func testFetchImageFromNetwork() async throws {
        XCTAssertTrue(mockFileManager.writtenFiles.isEmpty)
        XCTAssertEqual(MockURLProtocol.requests.count, 0)
        MockURLProtocol.responses[imageURL.absoluteString] = Data(repeating: 0xFF, count: 100)
        _ = try await networkService.fetchImage(from: imageURL)
        XCTAssertEqual(mockFileManager.writtenFiles.count, 1)
        XCTAssertEqual(MockURLProtocol.requests.count, 1)
    }

    func testFetchImageFromCache() async throws {
        MockURLProtocol.responses[imageURL.absoluteString] = Data(repeating: 0xFF, count: 100)
        XCTAssertTrue(mockFileManager.writtenFiles.isEmpty)
        _ = try await networkService.fetchImage(from: imageURL)
        // First request should make a network call and cache the result
        XCTAssertEqual(mockFileManager.writtenFiles.count, 1)
        XCTAssertEqual(MockURLProtocol.requests.count, 1)
        _ = try await networkService.fetchImage(from: imageURL)
        // Second request should use cache instead of making a network call
        XCTAssertEqual(MockURLProtocol.requests.count, 1)
        XCTAssertEqual(mockFileManager.writtenFiles.count, 1)
    }

    func testFetchImageError() async throws {
        MockURLProtocol.error = UnknownError.unknown
        do {
            _ = try await networkService.fetchImage(from: imageURL)
            XCTFail("Should throw a network error")
        } catch  {
            XCTAssertTrue(true)
        }
    }
}
