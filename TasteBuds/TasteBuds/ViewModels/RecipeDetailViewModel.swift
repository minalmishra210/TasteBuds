//
//  RecipeDetailViewModel.swift
//  TasteBuds
//
//  Created by Meenal Mishra on 03/08/24.
//

import Foundation

class RecipeDetailViewModel {
    private let recipe: Recipe

    var mealName: String {
        return recipe.strMeal
    }

    var mealInstructions: String {
        return recipe.strInstructions
    }

    var mealImageURL: URL? {
        return URL(string: recipe.strMealThumb)
    }

    var ingredients: [Ingredient] {
        return recipe.ingredients
    }

    var mealYouTubeURL: URL? {
        return URL(string: recipe.strYoutube)
    }
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
