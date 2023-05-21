//
//  RecipeInfo.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 14/05/2023.
//

import UIKit


class RecipeInfo: NSObject, Codable {
    
    var name: String?
    var amount: Double?
    var unitShort: String?
    
    struct IngredientList: Codable {
        var servings: Double?
        var aggregateLikes: Int?
        var healthScore: Double?
        var readyInMinutes: Int?
        var summary: String?
        var extendedIngredients: [AnIngredient]?
        var winePairing: Wines?
    }
    
    struct AnIngredient: Codable {
        var measures: MeasurementObj
        var name: String
    }
    
    struct MeasurementObj: Codable{
        var metric: MetricObj
    }
    
    struct MetricObj: Codable{
        var amount: Double
        var unitShort: String
    }
    
    struct Wines:Codable{
        var pairedWines: [String]?
        var pairingText: String?
    }
}
