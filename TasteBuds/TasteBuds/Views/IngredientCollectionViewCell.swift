//
//  IngredientCollectionViewCell.swift
//  TasteBuds
//
//  Created by Meenal Mishra on 03/08/24.
//

import Foundation
import UIKit

class IngredientCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ingredientImageView: UIImageView!
    @IBOutlet weak var ingredientLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with ingredient: Ingredient) {
        ingredientLabel.text = ingredient.name
        
        let baseURL = "https://www.themealdb.com/images/ingredients/"
        let imageUrlString = "\(baseURL)\(ingredient.name).png"
        
        if let imageUrl = URL(string: imageUrlString) {
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
