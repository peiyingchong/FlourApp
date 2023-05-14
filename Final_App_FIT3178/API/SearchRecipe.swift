//
//  SearchRecipe.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 14/05/2023.
//

import UIKit

class SearchRecipe: NSObject,Decodable {
    
    var recipes: [RecipeData]?
    
    private enum CodingKeys: String, CodingKey{
        case recipes = "results"
    }
    
    
    

}
