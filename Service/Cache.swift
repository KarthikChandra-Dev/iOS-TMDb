//
//  Cache.swift
//  iOS-TMDb
//
//  Created by Karthik Chandra Amudha on 9/19/21.
//

import Foundation
import UIKit

class Cache: NSObject {
    
    static let shared = Cache()
    private class StructWrapper<T>: NSObject {
        let value: T
        let created: Date

        init(_ _struct: T) {
            self.value = _struct
            self.created = Date()
        }
        
        func isStillValid() -> Bool {
            return (Date().timeIntervalSince(created)/60) < 120
        }
    }
    private let infoCache = NSCache<NSString, AnyObject>()
    
    private override init() { }
    
    // UIImage
    func add(_ image: UIImage, for key: String) {
        infoCache.setObject(image, forKey: key as NSString)
    }
    
    func image(for key: String) -> UIImage? {
        return infoCache.object(forKey: key as NSString) as? UIImage
    }
    
    // Meal
    func add(Meal meal: Meal, for key: String) {
        infoCache.setObject(StructWrapper<Meal>(meal), forKey: key as NSString)
    }
    
    func meal(for key: String) -> Meal? {
        if let wrapper = (infoCache.object(forKey: key as NSString) as? StructWrapper<Meal>), wrapper.isStillValid() {
            return wrapper.value
        }
        infoCache.removeObject(forKey: key as NSString)
        return nil
    }
    
    // CategoryMeals
    func add(CategoryMeals category: [CategoryMeal], for key: String) {
        infoCache.setObject(StructWrapper<[CategoryMeal]>(category), forKey: key as NSString)
    }
    
    func categoryMeals(for key: String) -> [CategoryMeal]? {
        if let wrapper = (infoCache.object(forKey: key as NSString) as? StructWrapper<[CategoryMeal]>), wrapper.isStillValid() {
            return wrapper.value
        }
        infoCache.removeObject(forKey: key as NSString)
        return nil
    }
    
    // Categories
    func add(Categories categories: Categories, for key: String) {
        infoCache.setObject(StructWrapper<Categories>(categories), forKey: key as NSString)
    }
    
    func categories(for key: String) -> Categories? {
        if let wrapper = (infoCache.object(forKey: key as NSString) as? StructWrapper<Categories>), wrapper.isStillValid() {
            return wrapper.value
        }
        infoCache.removeObject(forKey: key as NSString)
        return nil
    }
}
