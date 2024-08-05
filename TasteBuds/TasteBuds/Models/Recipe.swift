//
//  Recipe.swift
//  TasteBuds
//
//  Created by Meenal Mishra on 01/08/24.
//
import Foundation

struct RecipeResponse: Decodable {
    let meals: [Recipe]
}

// MARK: - Recipe

import Foundation

struct Recipe: Decodable {
    let idMeal: String
    let strMeal: String
    let strInstructions: String
    let strMealThumb: String
    let strYoutube: String
    let ingredients: [Ingredient]
    var isExpanded: Bool?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        strYoutube = try container.decode(String.self, forKey: .strYoutube)
        
        var tempIngredients = [Ingredient]()
        
        for i in 1...20 {
            if let name = try container.decodeIfPresent(String.self, forKey: CodingKeys(stringValue: "strIngredient\(i)")!),
               let quantity = try container.decodeIfPresent(String.self, forKey: CodingKeys(stringValue: "strMeasure\(i)")!),
               !name.isEmpty, !quantity.isEmpty {
                tempIngredients.append(Ingredient(name: name, quantity: quantity))
            }
        }
        ingredients = tempIngredients
    }
    
  enum CodingKeys: String, CodingKey {
        case idMeal
        case strMeal
        case strInstructions
        case strMealThumb
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
             strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
             strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15,
             strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5,
             strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10,
             strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15,
             strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
        case strYoutube
    }
}
