//
//  Category.swift
//  iOS-TMDb
//
//  Created by Karthik Chandra Amudha on 9/19/21.
//

import Foundation

// MARK: - CategoriesRoot
struct Categories: Decodable {
    private enum CodingKeys: String, CodingKey {
        case list = "categories"
    }
    let list: [Category]
}

// MARK: - Category
struct Category: Decodable {
    let id: String
    let name: String
    let thumbnail: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case thumbnail = "strCategoryThumb"
        case description = "strCategoryDescription"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
        self.description = try container.decode(String.self, forKey: .description)
    }
}

// MARK: - CategoryMealRoot
struct CategoryMealRoot: Decodable {
    private enum CodingKeys: String, CodingKey {
        case list = "meals"
    }
    let list: [CategoryMeal]
}

// MARK: - CategoryMeal
struct CategoryMeal: Decodable {
    let id: String
    let name: String
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnail = "strMealThumb"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
    }
}

