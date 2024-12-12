//
//  URLs.swift
//  FetchProject
//
//  Created by Nick Noble on 12/10/24.
//

import Foundation

/// Static urls to use for data fetching
enum URLs {
    static var recipes = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    static let malformed = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!
    static let empty = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!
}
