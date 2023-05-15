//
//  RecipeInfo.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 14/05/2023.
//

import UIKit


class RecipeInfo: NSObject, Decodable {
    
    var name: String?
    var amount: Double?
    var unitShort: String?
    
    struct IngredientList: Decodable {
        var servings: Double?
        var aggregateLikes: Int?
        var healthScore: Double?
        var readyInMinutes: Int?
        var summary: String?
        var extendedIngredients: [AnIngredient]?
        var winePairing: Wines?
    }
    
    struct AnIngredient: Decodable {
        var measures: MeasurementObj
        var name: String
    }
    
    struct MeasurementObj: Decodable{
        var metric: MetricObj
    }
    
    struct MetricObj: Decodable{
        var amount: Double
        var unitShort: String
    }
    
    struct Wines:Decodable{
        var pairedWines: [String]?
        var pairingText: String?
    }
}
