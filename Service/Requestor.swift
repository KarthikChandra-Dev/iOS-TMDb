//
//  Requestor.swift
//  iOS-TMDb
//
//  Created by Karthik Chandra Amudha on 9/19/21.
//

import Foundation

// MARK: - APIError
enum APIError: Error {
    case parsing(description: String)
    case failure(description: String)
    case networkNotReachable
}

// MARK: - Completion Handlers
typealias CategoriesCompletionBlock = (_ result: [Category]?, _ error: APIError?) -> Void
typealias CategoryCompletionBlock = (_ result: [CategoryMeal]?, _ error: APIError?) -> Void
typealias MealCompletionBlock = (_ result: Meal?, _ error: APIError?) -> Void

// MARK: - TheMealDB requests
class Requestor {
    static let shared = Requestor()
    private init() { }
    
    func requestCategoriesInfo(completion: @escaping CategoriesCompletionBlock) {
        
        if let categoriesObj: Categories = Cache.shared.categories(for: "categories") {
            completion(categoriesObj.list, nil)
            return
        }
          
        let reqUrl = "https://www.themealdb.com/api/json/v1/1/categories.php"
        request(withUrlString: reqUrl){ (data, error) in
            if error != nil {
                return completion(nil,error)
            }
            guard let data = data else {
                completion(nil, .failure(description: "Data is nil"))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(Categories.self, from: data)
                Cache.shared.add(Categories: decodedData, for: "categories")
                completion(decodedData.list, nil)
            } catch {
                completion(nil, .parsing(description: error.localizedDescription))
            }
        }
    }
    
    func requestCategoryMealsInfo(forCategory category: String, completion: @escaping CategoryCompletionBlock) {
        
        if let mealObj: [CategoryMeal] = Cache.shared.categoryMeals(for: category) {
            completion(mealObj, nil)
            return
        }
        
        let reqUrl = "https://www.themealdb.com/api/json/v1/1/filter.php?c=" + category
        request(withUrlString: reqUrl){ (data, error) in
            if error != nil {
                return completion(nil,error)
            }
            guard let data = data else {
                completion(nil, .failure(description: "Data is nil"))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(CategoryMealRoot.self, from: data)
                let received = decodedData.list
                Cache.shared.add(CategoryMeals: received, for: category)
                completion(received, nil)
            } catch {
                completion(nil, .parsing(description: error.localizedDescription))
            }
        }
    }
    
    func requestMealInfo(for id: String, completion: @escaping MealCompletionBlock) {
        
        if let mealObj: Meal = Cache.shared.meal(for: id) {
            completion(mealObj, nil)
            return
        }
        
        let reqUrl = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=" + id
        request(withUrlString: reqUrl){ (data, error) in
            if error != nil {
                return completion(nil,error)
            }
            guard let data = data else {
                completion(nil, .failure(description: "Data is nil"))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(MealsRoot.self, from: data)
                guard let received = decodedData.list.first else {
                    completion(nil, .failure(description: "Data is Invalid"))
                    return
                }
                Cache.shared.add(Meal: received, for: received.id)
                completion(received, nil)
            } catch {
                completion(nil, .parsing(description: error.localizedDescription))
            }
        }
    }
    
    
}


extension Requestor {
    private func request(withUrlString url: String, completionHandler: @escaping (Data?,  APIError?) -> Void) {
        guard Reachability().isNetworkReachable() else {
            return completionHandler(nil, .networkNotReachable)
        }
        
        guard let url = URL(string: url) else {
            print("Error")
            return completionHandler(nil, .failure(description: "Invalid Request Url"))
        }
        
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            
            guard error == nil else {
                print("Error")
                return completionHandler(nil, .failure(description: error?.localizedDescription ?? "Error: Request Failed"))
            }
            
            guard let responseData = data else {
                print("Data is nil")
                return completionHandler(nil, .failure(description: error?.localizedDescription ?? "Data is nil"))
            }
            
            return completionHandler(responseData, nil)
            
        })
        task.resume()
    }
}
