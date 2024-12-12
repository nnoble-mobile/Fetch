//
//  RecipeListViewModelTests.swift
//  Fetch
//
//  Created by Nick Noble on 12/12/24.
//


import XCTest
@testable import Fetch

final class RecipeListViewModelTests: XCTestCase {
    var viewModel: RecipeListViewModel!

    override func setUp() {
        super.setUp()
        viewModel = RecipeListViewModel(networkService: NetworkService.mock())
        MockURLProtocol.reset()
    }
    
    override func tearDown() {
        MockURLProtocol.reset()
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchRecipesSuccess() async {
        await viewModel.fetchRecipes()
        XCTAssertEqual(viewModel.recipes.count, 63)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    

    func testFetchRecipesEmpty() async {
        viewModel = RecipeListViewModel(
            networkService: NetworkService.mock(
                recipesUrl: URLs.empty
            )
        )

        await viewModel.fetchRecipes()
        XCTAssertTrue(viewModel.recipes.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testFetchRecipesUnexpectedError() async {
        MockURLProtocol.error = UnknownError.unknown
        await viewModel.fetchRecipes()
        XCTAssertTrue(viewModel.recipes.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "Unable to fetch recipes at this time. Please try again later.")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testFetchRecipesDecodingError() async {
        viewModel = RecipeListViewModel(
            networkService: NetworkService.mock(
                recipesUrl: URLs.malformed
            )
        )

        await viewModel.fetchRecipes()

        XCTAssertTrue(viewModel.recipes.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "Unable to fetch recipes at this time. Please try again later.")
        XCTAssertFalse(viewModel.isLoading)
    }

    func testLoadImageSuccess() async {
        let image = await viewModel.loadImage(for: PreviewData.singleRecipe)
        XCTAssertNotNil(image)
    }

    func testLoadImageNone() async {
        let image = await viewModel.loadImage(for: PreviewData.recipeNoImage)
        XCTAssertNil(image)
    }

    func testLoadImageError() async {
        MockURLProtocol.error = UnknownError.unknown
        let image = await viewModel.loadImage(for: PreviewData.singleRecipe)
        XCTAssertNil(image)
    }

    func testSearchFiltering() async {
        await viewModel.fetchRecipes()
        viewModel.searchText = "Apple"
        XCTAssertEqual(viewModel.filteredRecipes.count, 3)
    }
}

enum UnknownError: Error {
    case unknown
}
