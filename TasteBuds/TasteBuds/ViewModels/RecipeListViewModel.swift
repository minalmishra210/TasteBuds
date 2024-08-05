//
//  RecipeListViewModel.swift
//  TasteBuds
//
//  Created by Meenal Mishra on 03/08/24.
//

import Foundation
import UIKit

protocol ReloadView: AnyObject{
    func reloadData()
}

class RecipeListViewModel{
    
    private var recipes: [Recipe] = []
    var recipesDidChange: (() -> Void)?

    
    var numberOfRecipes: Int {
        return recipes.count
    }

    func recipe(at index: Int) -> Recipe {
        return recipes[index]
    }

    func fetchRecipes() async{
        Task {
            do {
                self.recipes = try await RecipeService().fetchRecipes()
                self.recipesDidChange?()
            } catch {
                DispatchQueue.main.async {
                    print("Error fetching recipes: \(error)")
                }
            }
        }
    }
    
}
