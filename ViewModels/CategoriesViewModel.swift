//
//  CategoriesViewModel.swift
//  iOS-TMDb
//
//  Created by Karthik Chandra Amudha on 9/19/21.
//

import Foundation

typealias ViewModelCompletionHandler = (_ result: Bool, _ error: APIError?) -> Void


class CategoriesViewModel {
    private var categories: [Category]?
    private var fetchCompletion: ViewModelCompletionHandler?
    private(set) var sorted: ListOrder = .ascending
    
    func setCompletionHandler(_ handler: @escaping ViewModelCompletionHandler) {
        self.fetchCompletion = handler
    }
    
    func fetch() {
        Requestor.shared.requestCategoriesInfo(completion: { [weak self] categoryList, error  in
            dump(categoryList)
            guard let list = categoryList else {
                if let errorCompletion = self?.fetchCompletion {
                    return errorCompletion(false, error)
                }
                return
            }
            self?.categories = list
            self?.sortCategories()
            if let listCompletion = self?.fetchCompletion {
                return listCompletion(true, nil)
            }
        })
    }
    
    func getCategoriesCount() -> Int {
        return categories?.count ?? 0
    }
    
    func getImageURL(forCategoryAt position: Int) -> String {
        guard let list = categories else {
            return ""
        }
        return list[position].thumbnail
    }
    
    func getTitle(forCategoryAt position: Int) -> String {
        guard let list = categories else {
            return ""
        }
        return list[position].name
    }
    
    func getDetail(forCategoryAt position: Int) -> String {
        guard let list = categories else {
            return ""
        }
        return list[position].description
    }
    
    func getInfoViewModel(forCategoryAt position: Int?) -> CategoryInfoViewModel? {
        guard let p = position, let category = categories?[p] else {
            return nil
        }
        let vm = CategoryInfoViewModel()
        vm.category = category
        return vm
    }
    
    func getMealsViewModel(forCategoryAt position: Int?) -> MealsViewModel? {
        guard let p = position, let category = categories?[p] else {
            return nil
        }
        let vm = MealsViewModel()
        vm.setCategory(category)
        return vm
    }
    
    func reOrder() {
        sorted = (sorted == .ascending) ? .descending: .ascending
        sortCategories()
        if let listCompletion = self.fetchCompletion {
            return listCompletion(true, nil)
        }
    }
    
    func sortCategories() {
        if sorted == .ascending {
            self.categories?.sort { return $0.name < $1.name }
        } else {
            self.categories?.sort { return $1.name < $0.name }
        }
    }
}
