//
//  RecipeStep.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 16/05/2023.
//

import UIKit

class RecipeStep: NSObject, Decodable {
    
    struct Instruction: Decodable {
        let steps: [Step]?
    }

    struct Step: Decodable {
        let equipment: [Equipment]?
        let ingredients: [Ingredient]?
        let number: Int?
        let step: String?
    }

    struct Equipment: Decodable {
        let id: Int?
        let image: String?
        let name: String?
        let temperature: Temperature?
    }

    struct Ingredient: Decodable {
        let id: Int?
        let image: String?
        let name: String?
    }

    struct Temperature: Decodable {
        let number: Double?
        let unit: String?
    }
    
}
