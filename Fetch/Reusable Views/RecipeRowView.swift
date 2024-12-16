//
//  RecipeRowView.swift
//  FetchProject
//
//  Created by Nick Noble on 12/10/24.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    @State private var recipeImage: UIImage?
    @State private var loading: Bool = false
    // The RecipeListViewModel is attached as a Binding so it can handle image retrieval
    @Binding var viewModel: RecipeListViewModel

    var body: some View {
        HStack {
            imageView

            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .task {
            // If the image is nil, have the viewModel fetch it
            if recipeImage == nil {
                loading = true
                recipeImage = await viewModel.loadImage(for: recipe)
                loading = false
            }
        }
    }

    @ViewBuilder
    private var imageView: some View {
        Group {
            if let image = recipeImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if loading {
                ProgressView()
            } else {
                Color.gray.opacity(0.3)

            }
        }
        .frame(width: 80, height: 80)
        .cornerRadius(10)
    }
}

#if DEBUG

// Shows a row with an image
#Preview {
    let recipes: [Recipe] = [PreviewData.singleRecipe]
    List(recipes) { recipe in
        RecipeRowView(
            recipe: recipe,
            viewModel: .constant(
                RecipeListViewModel(
                    networkService: NetworkService.mock()
                )
            )
        )
    }
}

// Shows a row without an image
#Preview("No Image") {
    let recipes: [Recipe] = [PreviewData.recipeNoImage]
    List(recipes) { recipe in
        RecipeRowView(
            recipe: recipe,
            viewModel: .constant(
                RecipeListViewModel(
                    networkService: NetworkService.mock()
                )
            )
        )
    }
}

#endif
