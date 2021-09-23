//
//  CategoryInfoViewModel.swift
//  iOS-TMDb
//
//  Created by Karthik Chandra Amudha on 9/20/21.
//

import Foundation

class CategoryInfoViewModel {
    var category: Category?
    
    func getImageUrlString() -> String {
        return category?.thumbnail ?? ""
    }
    
    func getTitle() -> String {
        return category?.name ?? ""
    }
    
    func getDescription() -> String {
        return category?.description ?? ""
    }
}
