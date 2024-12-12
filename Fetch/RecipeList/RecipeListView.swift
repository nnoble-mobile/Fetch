//
//  RecipeListView.swift
//  FetchProject
//
//  Created by Nick Noble on 12/10/24.
//


import SwiftUI

/// A List View to show all the recipes fetched from the API
struct RecipeListView: View {
    @State private var viewModel: RecipeListViewModel

    // Allows ViewModels to be injected for mocking
    init(_ viewModel: RecipeListViewModel = .init()) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Recipes...")
                } else if viewModel.errorMessage != nil {
                    ScrollView {
                        errorView
                    }
                } else if viewModel.recipes.isEmpty {
                    ScrollView {
                        notAvailable
                    }
                } else {
                    recipeList
                        .searchable(text: $viewModel.searchText, prompt: "Recipe Names")
                }
            }
            .navigationTitle("Recipes")
            .refreshable {
                await viewModel.fetchRecipes()
            }
        }

        .task {
            await viewModel.fetchRecipes()
        }
    }

    // The Recipe List view if data is found
    var recipeList: some View {
        List(viewModel.filteredRecipes) { recipe in
            RecipeRowView(recipe: recipe, viewModel: $viewModel)
        }
    }

    // The Empty view if data is not found
    @ViewBuilder
    var notAvailable: some View {
        ContentUnavailableView(
            "No Recipes Available",
            systemImage: "square.stack.3d.up.slash",
            description: Text("Pull to refresh")
        )
        .symbolEffect(.wiggle, options: .speed(1).repeat(1), isActive: true)
        .padding(.top, 100)
    }

    // The Error view if an error occurred
    var errorView: some View {
        ContentUnavailableView(
            "Oops! Something went wrong.",
            systemImage: "exclamationmark.triangle",
            description: Text("Pull to refresh")
        )
        .symbolEffect(.bounce, options: .speed(1).repeat(2), isActive: true)
        .padding(.top, 100)
    }

    // Refresh button to re-fetch recipes
    var refreshButton: some View {
        Button(action: {
            Task {
                await viewModel.fetchRecipes()
            }
        }) {
            Image(systemName: "arrow.clockwise")
        }
    }
}

#if DEBUG

// Shows a list of mocked recipe data
#Preview("Mock Data") {
    RecipeListView(
        RecipeListViewModel(
            networkService: NetworkService.mock()
        )
    )
}

// Shows the view if malformed data was fetched
#Preview("Malformed Data") {
    RecipeListView(
        RecipeListViewModel(
            networkService: NetworkService.mock(
                recipesUrl: URLs.malformed
            )
        )
    )
}

// Shows the view if no recipes were found
#Preview("Empty Data") {
    RecipeListView(
        RecipeListViewModel(
            networkService: NetworkService.mock(
                recipesUrl: URLs.empty
            )
        )
    )
}

#endif
