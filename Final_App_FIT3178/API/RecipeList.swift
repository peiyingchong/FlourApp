//
//  RecipeList.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 07/05/2023.
//

import UIKit

class RecipeList: NSObject,Decodable {
    
    var title: String?
    var ingredientList: String?
    
    private enum ingrediantListKeys: String, CodingKey{
        case title
        case ingredientList = "ingredients"
    }
    
    required init(from decoder: Decoder) throws{
        let rootContainer = try decoder.container(keyedBy: ingrediantListKeys.self)
        title = try rootContainer.decode(String.self, forKey: .title)
        if let ingredientArray = try? rootContainer.decode([String].self, forKey: .ingredientList){
            ingredientList = ingredientArray.joined(separator: ",")
        }
    }

}
