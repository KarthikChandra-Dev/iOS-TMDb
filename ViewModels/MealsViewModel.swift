//
//  MealsViewModel.swift
//  iOS-TMDb
//
//  Created by Karthik Chandra Amudha on 9/21/21.
//

import Foundation

//typealias CategoriesCompletionHandler = (_ result: Bool, _ error: APIError?) -> Void


class MealsViewModel {
    private var categoriesMeals: [CategoryMeal]?
    private var fetchCompletion: ViewModelCompletionHandler?
    private(set) var category: Category?
    private(set) var sorted: ListOrder = .ascending
    
    func setCompletionHandler(_ handler: @escaping ViewModelCompletionHandler) {
        self.fetchCompletion = handler
    }
    
    func fetch() {
        guard let c = self.category else {
            if let listCompletion = self.fetchCompletion {
                return listCompletion(false, .failure(description: "Invalid Category"))
            }
            return
        }
        
        Requestor.shared.requestCategoryMealsInfo(forCategory: c.name, completion: { [weak self] categoryMealsList, error  in
            dump(categoryMealsList)
            guard let list = categoryMealsList else {
                if let errorCompletion = self?.fetchCompletion {
                    return errorCompletion(false, error)
                }
                return
            }
            self?.categoriesMeals = list
            self?.sortCategories()
            if let listCompletion = self?.fetchCompletion {
                return listCompletion(true, nil)
            }
        })
    }
    
    func setCategory(_ category: Category?) {
        self.category = category
    }
    
    func getMealsCount() -> Int {
        return categoriesMeals?.count ?? 0
    }
    
    func getImageURL(forCategoryAt position: Int) -> String {
        guard let list = categoriesMeals else {
            return ""
        }
        return list[position].thumbnail
    }
    
    func getTitle(forCategoryAt position: Int) -> String {
        guard let list = categoriesMeals else {
            return ""
        }
        return list[position].name
    }
    
    func getMealDetailViewModel(forMealAt position: Int?) -> MealDetailViewModel? {
        guard let p = position, let meal = categoriesMeals?[p] else {
            return nil
        }
        let vm = MealDetailViewModel()
        vm.setCategoryMeal(meal)
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
            self.categoriesMeals?.sort { return $0.name < $1.name }
        } else {
            self.categoriesMeals?.sort { return $1.name < $0.name }
        }
    }
}
