//
//  IngredientTableViewCell.swift
//  TasteBuds
//
//  Created by Meenal Mishra on 03/08/24.
//

import Foundation
import UIKit

class IngredientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ingredientImageView: UIImageView!
    @IBOutlet weak var ingredientNameLabel: UILabel!
    @IBOutlet weak var ingredientQuantityLabel: UILabel!
    @IBOutlet weak var outerView: UIView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with ingredient: Ingredient) {
        ingredientNameLabel.text = ingredient.name
        ingredientQuantityLabel.text = ingredient.quantity
        
        if let imageUrl = URL(string: "https://www.themealdb.com/images/ingredients/\(ingredient.name).png") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        self.ingredientImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}
