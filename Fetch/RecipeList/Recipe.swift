//
//  Recipe.swift
//  FetchProject
//
//  Created by Nick Noble on 12/10/24.
//


import Foundation

/// The wrapper object that holds an array of Recipes. Represents the root JSON object from the API
struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

/// Represents the nested JSON object for Recipes from the API
struct Recipe: Identifiable, Codable, Equatable {
    let id: UUID
    let cuisine: String
    let name: String
    let photoUrlLarge: URL?
    let photoUrlSmall: URL?
    let sourceUrl: URL?
    let youtubeUrl: URL?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}
