import UIKit

class RecipeListViewController: UIViewController {
    
    private var viewModel = RecipeListViewModel()
    private var meals: [Recipe] = []
    @IBOutlet weak var tableView: UITableView!
    
    var expandedIndexPaths: Set<IndexPath> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        fetchRecipes()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    private func fetchRecipes() {
        Task {
            do {
                self.meals = try await RecipeService().fetchRecipes()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error fetching recipes: \(error)")
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.recipesDidChange = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension RecipeListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
           return 350.0 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        cell.selectionStyle = .none
        cell.recipe = meals[indexPath.row]
        cell.mealDescriptionLabel.tag = indexPath.row
        cell.reloadDelegate = self
        return cell
    }
    @objc func readMoreButton(_ sender: UIButton) {
           let rowIndex = sender.tag
           let indexPath = IndexPath(row: rowIndex, section: 0)
           
           if expandedIndexPaths.contains(indexPath) {
               expandedIndexPaths.remove(indexPath)
           } else {
               expandedIndexPaths.insert(indexPath)
           }
           
           tableView.reloadRows(at: [indexPath], with: .automatic)
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let recipeDetail = storyboard.instantiateViewController(withIdentifier: "RecipeDetailViewController") as! RecipeDetailViewController
        let model = RecipeDetailViewModel(recipe: meals[indexPath.row])
        recipeDetail.viewModel = model
        recipeDetail.modalPresentationStyle = .fullScreen
        self.present(recipeDetail,animated: true,completion: nil)
    }
}
extension RecipeListViewController: ReloadDelegate{
    func reloadCell(index: Int) {
        meals[index].isExpanded = !(meals[index].isExpanded ?? false)
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
}


extension RecipeListViewController: ReloadView{
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


