//
//  Logger.swift
//  FetchProject
//
//  Created by Nick Noble on 12/10/24.
//

@_exported import OSLog // Make this available everywhere

// Convenience init for a logger that always uses the bundleId as the subsystem
extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "not_found"
    static let `default` = Logger()
    static let network = Logger(category: "Network")

    init(category: String = "General") {
        self.init(subsystem: Self.subsystem, category: category)
    }
}
