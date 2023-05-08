//
//  Search_Recipes.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 07/05/2023.
//

import UIKit

class Search_Recipes: NSObject,Decodable {
    
    var title: String?
    var imageURL: String?
    var id: Int?
    
    private enum RootKeys: String, CodingKey, Decodable {
        case results
    }
    
    private enum SearchRecipesKeys: String, CodingKey {
        case title
        case id
        case imageURL = "image"
        
    }
   
    
    required init(from decoder: Decoder) throws {
        //Get the result container first
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        
        //then get the recipes inside the results container
        let recipeSearchContainer = try rootContainer.nestedContainer(keyedBy: SearchRecipesKeys.self, forKey: .results)
        
        id = try recipeSearchContainer.decode(Int.self, forKey: .id)
        title = try recipeSearchContainer.decode(String.self, forKey:  .title)
        imageURL = try recipeSearchContainer.decode(String.self, forKey: .imageURL)
        
        
        
    }

}
