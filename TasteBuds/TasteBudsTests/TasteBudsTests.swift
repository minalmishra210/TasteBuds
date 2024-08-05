//
//  TasteBudsTests.swift
//  TasteBudsTests
//
//  Created by Meenal Mishra on 01/08/24.
//

import XCTest
@testable import TasteBuds

final class TasteBudsTests: XCTestCase {
    var recipeService: RecipeService!

    override func setUp() {
        super.setUp()
        recipeService = RecipeService()
    }

    override func tearDown() {
        recipeService = nil
        super.tearDown()
    }

    func testFetchRecipes() async {
        do {
            let recipes = try await recipeService.fetchRecipes()
            XCTAssertNotNil(recipes)
            XCTAssertGreaterThan(recipes.count, 0)
        } catch {
            XCTFail("Error: \(error.localizedDescription)")
        }
    }
}
