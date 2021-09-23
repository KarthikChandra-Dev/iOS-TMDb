//
//  MealDetailViewModel.swift
//  iOS-TMDb
//
//  Created by Karthik Chandra Amudha on 9/22/21.
//

import Foundation

class MealDetailViewModel {
    private var meal: Meal?
    private var fetchCompletion: ViewModelCompletionHandler?
    private(set) var categoryMeal: CategoryMeal?
    
    func setCompletionHandler(_ handler: @escaping ViewModelCompletionHandler) {
        self.fetchCompletion = handler
    }
    
    func fetch() {
        guard let c = self.categoryMeal else {
            if let listCompletion = self.fetchCompletion {
                return listCompletion(false, .failure(description: "Invalid Meal Detail"))
            }
            return
        }
        
        Requestor.shared.requestMealInfo(for: c.id, completion: { [weak self] mealDetail, error  in
            dump(mealDetail)
            guard let meal = mealDetail else {
                if let errorCompletion = self?.fetchCompletion {
                    return errorCompletion(false, error)
                }
                return
            }
            self?.meal = meal
            if let listCompletion = self?.fetchCompletion {
                return listCompletion(true, nil)
            }
        })
    }
    
    func setCategoryMeal(_ cMeal: CategoryMeal?) {
        self.categoryMeal = cMeal
    }
    
    func getImageURL() -> String {
        guard let mealDetail = meal else {
            return ""
        }
        return mealDetail.thumbnail
    }
    
    func getTitle() -> String {
        guard let mealDetail = meal else {
            return ""
        }
        return mealDetail.name
    }
    
    func getInstructions() -> String {
        guard let mealDetail = meal else {
            return ""
        }
        return mealDetail.instructions
    }
    
    func getIngredientsInfo() -> String {
        guard let mealDetail = meal else {
            return ""
        }
        var info = ""
        for ingredient in mealDetail.ingredients {
            info += ingredient.getIngredientDetail() + "\n"
        }
        return info
    }
}
