//
//  DataCacheTests.swift
//  FetchProject
//
//  Created by Nick Noble on 12/11/24.
//


import XCTest
@testable import Fetch

class DataCacheTests: XCTestCase {
    var dataCache: DataCache!
    var mockFileManager: MockFileManager!
    
    override func setUp() {
        super.setUp()
        mockFileManager = MockFileManager()
        dataCache = DataCache(fileManager: mockFileManager)
    }
    
    override func tearDown() {
        dataCache = nil
        mockFileManager = nil
        super.tearDown()
    }
    
    func testSetAndGetImage() {
        let testURL = URL(string: "https://example.com/image.jpg")!
        let imageData = Data(repeating: 0xFF, count: 100)
        dataCache.set(imageData, for: testURL)
        let retrievedData = dataCache.get(testURL)
        XCTAssertEqual(retrievedData, imageData)
    }

    func testPerformanceOfCaching() {
        let testURL = URL(string: "https://example.com/largeimage.jpg")!
        let largeImageData = Data(repeating: 0xFF, count: 1_000_000) // 1MB of data
        measure {
            dataCache.set(largeImageData, for: testURL)
            _ = dataCache.get(testURL)
        }
    }
}
