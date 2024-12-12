//
//  MockFileManager.swift
//  FetchProject
//
//  Created by Nick Noble on 12/11/24.
//

import Foundation

/// A mock FileManager that saves data to memory instead of to disk
class MockFileManager: FileManager {
    var writtenFiles: [String: Data] = [:]

    override func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {
        // do nothing
    }

    override func fileExists(atPath path: String) -> Bool {
        return writtenFiles.keys.contains(path)
    }

    override func contents(atPath path: String) -> Data? {
        writtenFiles[path]
    }

    override func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]? = nil) -> Bool {
        if let data {
            writtenFiles[path] = data
        }
        return true
    }
}
