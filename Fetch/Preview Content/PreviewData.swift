//
//  Untitled.swift
//  FetchProject
//
//  Created by Nick Noble on 12/10/24.
//

import Foundation

/// A convenient place to store data for Previews
struct PreviewData {
    static let recipes: [Recipe] = {
        let recipeResponse: RecipeResponse = loadJSON("recipes")
        return recipeResponse.recipes
    }()

    static var singleRecipe: Recipe {
        recipes.first!
    }

    static let recipeNoImage = Recipe(
        id: UUID(),
        cuisine: "American",
        name: "New York Cheesecake",
        photoUrlLarge: nil,
        photoUrlSmall: nil,
        sourceUrl: URL(string: "https://www.bbcgoodfood.com/recipes/2869/new-york-cheesecake"),
        youtubeUrl: URL(string: "https://www.youtube.com/watch?v=tspdJ6hxqnc")
    )

    /// Load JSON from the bundle as Data
    static func jsonData(_ fileName: String) -> Data {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            fatalError("Preview data for \(fileName) does not exist")
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            fatalError("Error: Failed to load \(fileName).json - \(error.localizedDescription)")
        }
    }

    /// Load JSON from the bundle as a Codable Object
    static func loadJSON<T: Codable>(_ fileName: String) -> T {
        do {
            let data = jsonData(fileName)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            fatalError("Error: Failed to decode \(fileName).json - \(error.localizedDescription)")
        }
    }
}
