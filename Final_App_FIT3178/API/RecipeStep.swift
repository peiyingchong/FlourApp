//
//  RecipeStep.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 16/05/2023.
//

import UIKit

class RecipeStep: NSObject, Codable {
    
    struct Instruction: Codable {
        let steps: [Step]?
    }

    struct Step: Codable {
        let equipment: [Equipment]?
        let ingredients: [Ingredient]?
        let number: Int
        let step: String
    }

    struct Equipment: Codable {
        let id: Int?
        let image: String?
        let name: String?
        let temperature: Temperature?
    }

    struct Ingredient: Codable {
        let id: Int?
        let image: String?
        let name: String?
    }

    struct Temperature: Codable {
        let number: Double?
        let unit: String?
    }
    
}
