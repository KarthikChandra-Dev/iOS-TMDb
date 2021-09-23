//
//  CategoryInfoViewController.swift
//  iOS-TMDb
//
//  Created by Karthik Chandra Amudha on 9/20/21.
//

import UIKit

class CategoryInfoViewController: UIViewController {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryDetailTextView: UITextView!
    
    var viewModel: CategoryInfoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: viewModel?.getImageUrlString() ?? "") {
            self.categoryImageView.loadImage(from: url, placeholder: UIImage(named: "plateDetail" ))
        }
        self.categoryTitle.text = viewModel?.getTitle()
        self.categoryDetailTextView.text = viewModel?.getDescription()
        self.categoryDetailTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }
    
    func setCategoryInfoViewModel(model: CategoryInfoViewModel) {
        self.viewModel = model
    }
}
