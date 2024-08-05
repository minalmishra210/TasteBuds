//
//  RecipeTableViewCell.swift
//  TasteBuds
//
//  Created by Meenal Mishra on 03/08/24.
//

import Foundation
import UIKit

protocol ReloadDelegate: AnyObject{
    func reloadCell(index: Int)
}
class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealDescriptionLabel: UILabel!
  //  @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var ingredientsCollectionView: UICollectionView!
    @IBOutlet weak var wishlistButton: UIButton!
    
    weak var reloadDelegate: ReloadDelegate?
    private var ingredients: [Ingredient] = []
    var isExpanded: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
        setupCollectionView()
    }
    
    private func setUpUI(){
        contentView.roundCorners(radius: 10, borderWidth: 1, borderColor: .clear)
        mealImageView.roundCorners(radius: 10, borderWidth: 1, borderColor: .clear)
        outerView.roundCorners(radius: 10, borderWidth: 1, borderColor: .clear)
        outerView.addShadow(color: .lightGray, opacity: 0.5, offset: CGSize(width: 0, height: 2), radius: 10)
        wishlistButton.setCornerRadius(radius: 5, borderWidth: 1, borderColor: .clear)
        wishlistButton.setShadow(color: .lightGray, opacity: 0.3, offset: CGSize(width: 0, height: 2), radius: 3)
    }
    
    private func setupCollectionView() {
        ingredientsCollectionView.dataSource = self
        ingredientsCollectionView.delegate = self
    }
    
    var recipe: Recipe? {
        didSet {
            guard let meal = recipe else { return }
            mealNameLabel.text = meal.strMeal
            mealDescriptionLabel.text = meal.strInstructions
           // mealDescriptionLabel.text = isExpanded ? meal.strInstructions : String(meal.strInstructions.prefix(50)) + (meal.strInstructions.count > 100 ? "..." : "")
            ingredients = meal.ingredients
            if mealDescriptionLabel.maxNumberOfLines > 3 && !(meal.isExpanded ?? false ) {
                mealDescriptionLabel.numberOfLines = 3
                DispatchQueue.main.async {
                    self.mealDescriptionLabel.addTrailing(with: "", moreText: " \(Const.viewMore)", moreTextFont: .boldSystemFont(ofSize: 16), moreTextColor: .systemTeal)
                    let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
                    self.mealDescriptionLabel.isUserInteractionEnabled = true
                    self.mealDescriptionLabel.addGestureRecognizer(tapAction)
                }
            }else if meal.isExpanded ?? false {
                mealDescriptionLabel.numberOfLines = 0
                DispatchQueue.main.async {
                    self.mealDescriptionLabel.addTrailingViewLess(lessText: " \(Const.viewLess)", moreTextFont: .boldSystemFont(ofSize: 16), moreTextColor: .systemTeal)
                    let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
                    self.mealDescriptionLabel.isUserInteractionEnabled = true
                    self.mealDescriptionLabel.addGestureRecognizer(tapAction)
                }
            }
            ingredientsCollectionView.reloadData()
            
            if let imageUrl = URL(string: meal.strMealThumb) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: imageUrl) {
                        DispatchQueue.main.async {
                            self.mealImageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let moreRange = ("\(mealDescriptionLabel.text ?? "")" as NSString).range(of: Const.viewMore)
        let lessRange = ("\(mealDescriptionLabel.text ?? "")" as NSString).range(of: Const.viewLess)
        if gesture.didTapAttributedTextInLabel(label: mealDescriptionLabel, inRange: moreRange) {
            reloadDelegate?.reloadCell(index: mealDescriptionLabel.tag)
        }else if gesture.didTapAttributedTextInLabel(label: mealDescriptionLabel, inRange: lessRange) {
            reloadDelegate?.reloadCell(index: mealDescriptionLabel.tag)
        }
    }
//    @IBAction func viewMoreTapped(_ sender: UIButton) {
//        isExpanded.toggle()
//        mealDescriptionLabel.text = isExpanded ? recipe?.strInstructions : String(recipe?.strInstructions.prefix(30) ?? "") + (recipe?.strInstructions.count ?? 0 > 50 ? "..." : "")
//        readMoreButton.setTitle(isExpanded ? "View Less" : "View More", for: .normal)
//        if let tableView = superview as? UITableView {
//            tableView.beginUpdates()
//            tableView.endUpdates()
//        }
//    }
}

extension RecipeTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientCell", for: indexPath) as! IngredientCollectionViewCell
        cell.ingredientImageView.roundCorners(radius: 6, borderWidth: 1, borderColor: .lightGray)
        let ingredient = ingredients[indexPath.row]
        cell.configure(with: ingredient)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

