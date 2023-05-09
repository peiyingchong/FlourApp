//
//  RecipeAnalysis.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 07/05/2023.
//

import UIKit

class RecipeAnalysis: NSObject, Decodable {
    
    
    private enum RootKeys: String, CodingKey {
        case steps
    }
    
    private enum stepOverviewKeys: String, CodingKey{
        case equipment
        case ingredients
        case stepNumber = "number"
        case stepDescription = "step"
    }
    
}
