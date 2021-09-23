//
//  CategoriesViewController.swift
//  iOS-TMDb
//
//  Created by Karthik Chandra Amudha on 9/19/21.
//

import UIKit

enum ListOrder {
    case ascending
    case descending
    
    func title() -> String {
        switch self {
        case .ascending:
            return "Z ⇒ A"
        case .descending:
            return "A ⇒ Z"
        }
    }
}


class CategoriesViewController: UIViewController {
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //private var detailedIndex: IndexPath?
    private var currentIndex: IndexPath?
    private let viewModel: CategoriesViewModel = CategoriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sort = UIBarButtonItem(title: ListOrder.ascending.title(),
                                   style: .plain,
                                   target: self,
                                   action: #selector(reOrder(_:)))
        navigationItem.rightBarButtonItem = sort
        navigationItem.title = "Categories"
        categoriesTableView.tableHeaderView = UIView()
        categoriesTableView.tableFooterView = UIView()
        
        viewModel.setCompletionHandler({result, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.categoriesTableView.reloadData()
                }
            } 
        })
        self.viewModel.fetch()
    }
    
    @objc func reOrder(_ sender:UIBarButtonItem!)
    {
        self.viewModel.reOrder()
        sender.title =  self.viewModel.sorted.title()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else {
            currentIndex = nil
            return
        }
        if segueId == "CategoryMealsSegue" {
            if let vc = segue.destination as? MealsViewController {
                if let vm = self.viewModel.getMealsViewModel(forCategoryAt: self.currentIndex?.row) {
                    vc.setMealsViewModel(model: vm)
                }
            }
        } else if segueId == "CategoryInfoSegue" {
            if let vc = segue.destination as? CategoryInfoViewController {
                if let vm = self.viewModel.getInfoViewModel(forCategoryAt: self.currentIndex?.row) {
                    vc.setCategoryInfoViewModel(model: vm)
                }
            }
        }
        currentIndex = nil
    }

}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCategoriesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryDetailTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCustomCell", for: indexPath) as! CategoryDetailTableViewCell
        if let url = URL(string: viewModel.getImageURL(forCategoryAt: indexPath.row)) {
            cell.categoryThumbnailImageView?.loadImage(from: url, placeholder: UIImage(named: "plate"))
        }
        cell.categoryTitleLabel?.text = viewModel.getTitle(forCategoryAt: indexPath.row)
        cell.categoryDetailLabel?.text = viewModel.getDetail(forCategoryAt: indexPath.row)
        return cell
    }

}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "CategoryMealsSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        currentIndex = indexPath
        performSegue(withIdentifier: "CategoryInfoSegue", sender: self)
    }
}
