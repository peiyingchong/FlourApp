//
//  APICallerForHome.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 22/05/2023.
//

import Foundation

class APICaller{
    static let shared = APICaller()
    
    func getVeganRecipes(completion: @escaping (Result<[RecipeData],Error>) ->Void){
        guard let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?diet=vegan&apiKey=8a20103f31cd4cd49daadeeb8dfc99d8") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url))
        {data, _, error in guard let data = data, error == nil else{
            return
            
        }
            do {
                let results = try JSONDecoder().decode(SearchRecipe.self, from: data)
                completion(.success(results.recipes ?? []))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
//    func getVeganRecipes(){
//        let url = "https://api.spoonacular.com/recipes/complexSearch?diet=vegan&apiKey=8a20103f31cd4cd49daadeeb8dfc99d8"
//        performApiReq(url: url)
//    }
//
//    func performApiReq(url:String){
//        Task{
//            //check for valid url string
//            guard let urlReq = URL(string:url) else{
//                print("Invalid URL")
//                return
//            }
//            //api request
//            await getRecipes(url: urlReq)
//        }
//    }
//
//    func getRecipes(url: URL) async{
//        do{
//            let(data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
//
//            //create a JSONDecoder instance
//            let decoder = JSONDecoder()
//
//            //Because the data returned is a JsonObject, and the field wanted is an array of Json Object
//            let resultContainer = try decoder.decode(SearchRecipe.self, from: data)
//
//            if let recipe = resultContainer.recipes{
//                for item in recipe {
//                    veganRecipes.append(item)
//                }
//            }
//        }
//        catch let error{
//            print(error)
//        }
//    }
    
    
}
