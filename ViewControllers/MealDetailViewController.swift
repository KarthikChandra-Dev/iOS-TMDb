//
//  MealDetailViewController.swift
//  iOS-TMDb
//
//  Created by Karthik Chandra Amudha on 9/22/21.
//

import UIKit

class MealDetailViewController: UIViewController {
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealTitleLabel: UILabel!
    @IBOutlet weak var mealIngredientsLabel: UILabel!
    @IBOutlet weak var mealInstructionsLabel: UILabel!
    
    private var viewModel: MealDetailViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel?.getTitle()
        
        viewModel?.setCompletionHandler({result, error in
            if error == nil {
                DispatchQueue.main.async {
                    if let url = URL(string: self.viewModel?.getImageURL() ?? "") {
                        self.mealImageView.loadImage(from: url, placeholder: UIImage(named: "plateDetail"))
                    }
                    self.mealTitleLabel.text = self.viewModel?.getTitle()
                    self.mealIngredientsLabel.text = self.viewModel?.getIngredientsInfo()
                    self.mealInstructionsLabel.text = self.viewModel?.getInstructions()
                }
            }
        })
        self.viewModel?.fetch()
    }
    
    func setMealDetailViewModel(model: MealDetailViewModel) {
        self.viewModel = model
    }
    
}
