//
//  RecipeViewModel.swift
//  FetchProject
//
//  Created by Nick Noble on 12/10/24.
//

import Observation
import UIKit

@Observable
class RecipeListViewModel {
    var recipes: [Recipe] = []
    var isLoading = false
    var errorMessage: String?
    var searchText: String = ""

    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            recipes
        } else {
            recipes.filter { $0.name.contains(searchText) }
        }
    }

    private let networkService: NetworkService

    // Dependency injection for the network service
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }

    func fetchRecipes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            recipes = try await networkService.fetchRecipes()
        } catch {
            errorMessage = "Unable to fetch recipes at this time. Please try again later."
        }
        
        isLoading = false
    }

    /// Load an image for a particular recipe. This function gets called by each row in the list.
    /// Images are cached after retrieval. Uses UIKit for `UIImage` since SwiftUI's `Image`
    /// can't be converted to/from `Data`
    func loadImage(for recipe: Recipe) async -> UIImage? {
        guard let urlString = recipe.photoUrlSmall else { return nil }
        do {
            let imageData = try await networkService.fetchImage(from: urlString)
            return UIImage(data: imageData)
        } catch {
            Logger.default.error("Failed to load image: \(error.localizedDescription)")
            return nil
        }
    }
}
