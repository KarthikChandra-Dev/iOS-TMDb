//
//  Meal.swift
//  iOS-TMDb
//
//  Created by Karthik Chandra Amudha on 9/19/21.
//

import Foundation

// MARK: - Ingredient
struct Ingredient {
    let name: String
    let measurement: String
}

// MARK: - Meal
struct Meal: Decodable {
    
    let id: String
    let name: String
    let thumbnail: String
    let instructions: String
    var ingredients: [Ingredient]

    private struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: CodingKeys(stringValue: "idMeal")!)
        self.name = try container.decode(String.self, forKey: CodingKeys(stringValue: "strMeal")!)
        self.thumbnail = try container.decode(String.self, forKey: CodingKeys(stringValue: "strMealThumb")!)
        self.instructions = try container.decode(String.self, forKey: CodingKeys(stringValue: "strInstructions")!)
        self.ingredients = [Ingredient]()
        let totalIngredients = container.allKeys.filter({ key in
            key.stringValue.hasPrefix("strIngredient")
        })
        for key in totalIngredients {
            let strKey = key.stringValue
            let decodedIngredient = try container.decode(String.self, forKey: CodingKeys(stringValue: strKey)!)
            let decodedMeasure = try container.decode(String.self, forKey: CodingKeys(stringValue: "strMeasure" + String(strKey.dropFirst("strIngredient".count)))!)
            if !(decodedIngredient.trimmingCharacters(in: CharacterSet(charactersIn: " ")).isEmpty) {
                self.ingredients.append(Ingredient(name: decodedIngredient, measurement: decodedMeasure))
            }
        }
    }
}

// MARK: - MealRoot
struct MealsRoot: Decodable {
    enum CodingKeys: String, CodingKey {
        case list = "meals"
    }
    let list: [Meal]
}
