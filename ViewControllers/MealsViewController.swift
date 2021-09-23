//
//  MealsViewController.swift
//  iOS-TMDb
//
//  Created by Karthik Chandra Amudha on 9/21/21.
//

import UIKit

class MealsViewController: UIViewController {
    
    @IBOutlet weak var mealsTableView: UITableView!
    
    private var viewModel: MealsViewModel?
    private var currentIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sort = UIBarButtonItem(title: ListOrder.ascending.title(),
                                   style: .plain,
                                   target: self,
                                   action: #selector(reOrder(_:)))
        navigationItem.rightBarButtonItem = sort
        navigationItem.title = viewModel?.category?.name
        mealsTableView.tableHeaderView = UIView()
        mealsTableView.tableFooterView = UIView()
        
        viewModel?.setCompletionHandler({result, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.mealsTableView.reloadData()
                }
            }
        })
        self.viewModel?.fetch()
    }
    
    @objc func reOrder(_ sender:UIBarButtonItem!)
    {
        self.viewModel?.reOrder()
        sender.title =  self.viewModel?.sorted.title()
    }
    
    func setMealsViewModel(model: MealsViewModel) {
        self.viewModel = model
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else {
            currentIndex = nil
            return
        }
        if segueId == "MealDetailSegue" {
            if let vc = segue.destination as? MealDetailViewController {
                if let vm = self.viewModel?.getMealDetailViewModel(forMealAt: self.currentIndex?.row) {
                    vc.setMealDetailViewModel(model: vm)
                }
            }
        }
        currentIndex = nil
    }

}

extension MealsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getMealsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MealTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as! MealTableViewCell
        if let url = URL(string: viewModel?.getImageURL(forCategoryAt: indexPath.row) ?? "") {
            cell.mealImageView.loadImage(from: url, placeholder: UIImage(named: "plate"))
        }
        cell.mealTitle.text = viewModel?.getTitle(forCategoryAt: indexPath.row)
        return cell
    }

}

extension MealsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "MealDetailSegue", sender: self)
    }
}

