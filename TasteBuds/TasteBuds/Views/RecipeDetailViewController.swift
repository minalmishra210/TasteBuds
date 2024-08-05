//
//  RecipeDetailViewController.swift
//  TasteBuds
//
//  Created by Meenal Mishra on 03/08/24.
//

import UIKit
import WebKit

class RecipeDetailViewController: UIViewController {
    
    var viewModel: RecipeDetailViewModel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UIView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var noOfItemsLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var dashView: UIView!
    @IBOutlet weak var viewOnYoutubeButton: UIButton!
    let scrollView = UIScrollView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindViewModel()
        addscrollView()
        setUpTableView()
    }

     func setUpUI(){
        noOfItemsLabel.text = "\(viewModel.ingredients.count) items"
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        dashView.roundCorners(radius: 12, borderWidth: 1, borderColor: .clear)
        viewOnYoutubeButton.setCornerRadius(radius: 5, borderWidth: 1, borderColor: .clear)
        closeButton.setCornerRadius(radius: 5, borderWidth: 1, borderColor: .clear)
        closeButton.setShadow(color: .clear, opacity: 0.3, offset: CGSize(width: 0, height: 2), radius: 3)
        heartButton.setCornerRadius(radius: 5, borderWidth: 1, borderColor: .clear)
        heartButton.setShadow(color: .clear, opacity: 0.3, offset: CGSize(width: 0, height: 2), radius: 3)
    }
    
     func setUpTableView() {
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        ingredientsTableView.rowHeight = UITableView.automaticDimension
        ingredientsTableView.separatorStyle = .none
    }
    
     func bindViewModel() {
        mealNameLabel.text = viewModel.mealName
      //  descriptionLabel.text = viewModel.mealInstructions
        
        if let imageURL = viewModel.mealImageURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self.mealImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    func addscrollView(){
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = viewModel.mealInstructions
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(label)
        
        descriptionLabel.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            label.topAnchor.constraint(equalTo: scrollView.topAnchor),
            label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            label.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        scrollView.contentSize = label.bounds.size
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func youtubeButtonTapped(_ sender: UIButton) {
        guard let recipe = viewModel, let youtubeURL = viewModel.mealYouTubeURL
        else { return }
               if UIApplication.shared.canOpenURL(youtubeURL) {
                   UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
               }
    }
    
}

extension RecipeDetailViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
        cell.ingredientImageView.roundCorners(radius: 10, borderWidth: 1, borderColor: .clear)
        cell.outerView.roundCorners(radius: 10, borderWidth: 1, borderColor: .clear)
        cell.outerView.addShadow(color: .lightGray, opacity: 0.5, offset: CGSize(width: 0, height: 2), radius: 10)
        let ingredient = viewModel.ingredients[indexPath.row]
        cell.configure(with: ingredient)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class TableViewAdjustedHeight: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
