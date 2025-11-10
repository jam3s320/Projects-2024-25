//
//  MenuData.swift
//  Test
//
//  Created by Larry Liu on 2/22/24.
//

import Foundation

struct MenuDecoder: Decodable {
    let specials: [Item]
    let daily: [Item]
    let desserts: [Item]
    let salads: [Item]
    let sidesAndVegetables: [Item]
    let soups: [Item]
    let entrees: [Item]
    
    struct Item: Decodable {
        let id: String
        let name: String
        let menuId: String
        let recipeId: String
        let recipeType: String
        let displayCategory: String
        let dailyCategory: String
        let displayStation: String
        let allergens: Allergens
        let lifestyleCodes: [String]?
        let lifestyleNames: [String]?
    }
    struct Allergens: Decodable {
        let allergenNames: [String]
        let allergenCodes: [String]
    }

    enum CodingKeys: String, CodingKey {
        case specials = "Specials"
        case daily = "Daily"
        case desserts = "Desserts"
        case salads = "Salads"
        case sidesAndVegetables = "Sides and Vegetables"
        case soups = "Soups"
        case entrees = "Entrées"
    }
}
