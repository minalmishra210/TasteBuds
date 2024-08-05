//
//  RecipeService.swift
//  TasteBuds
//
//  Created by Meenal Mishra on 01/08/24.
//

import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes() async throws -> [Recipe]
}
class RecipeService: RecipeServiceProtocol  {
    private let baseURL = "https://www.themealdb.com/api/json/v2/1/randomselection.php"

    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
        return recipeResponse.meals
    }
    
}
